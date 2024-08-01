//
//  PokemonScannerViewModel.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 30/07/24.
//

import Foundation

import UIKit
import CoreML
import Vision
import ImageIO

protocol PokemonScannerViewModelDelegate: AnyObject {
    func didFinishClassification(identifier: String, confidence: Float)
    func didFailClassification(error: PokemonScannerError)
}

final class PokemonScannerViewModel {
    
    private let requestProvider: ClassificationRequestProvider
    private let dataPersistence: PokemonDataPersistence
    private let imageProcessor: ImageProcessor
    private let visionRequestHandlerFactory: ImageRequestHandlerFactory
    
    weak var delegate: PokemonScannerViewModelDelegate?
    
    init(
        delegate: PokemonScannerViewModelDelegate,
        requestProvider: ClassificationRequestProvider = MLModelRequestProvider(),
        dataPersistence: PokemonDataPersistence = CoreDataPokemonDataPersistence(),
        imageProcessor: ImageProcessor = DefaultImageProcessor(),
        visionRequestHandlerFactory: ImageRequestHandlerFactory = VisionImageRequestHandlerFactory()
    ) {
        self.delegate = delegate
        self.requestProvider = requestProvider
        self.dataPersistence = dataPersistence
        self.imageProcessor = imageProcessor
        self.visionRequestHandlerFactory = visionRequestHandlerFactory
    }
    
    func updateClassifications(for image: UIImage) {
        guard let classificationRequest = requestProvider.createClassificationRequest(completionHandler: processClassifications) else {
            delegate?.didFailClassification(error: .modelLoadingFailed)
            return
        }
        
        let orientation = imageProcessor.getCGImagePropertyOrientation(from: image)
        guard let ciImage = imageProcessor.createCIImage(from: image) else {
            delegate?.didFailClassification(error: .imageProcessingFailed)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [visionRequestHandlerFactory] in
            let handler = visionRequestHandlerFactory.makeImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([classificationRequest])
            } catch {
                self.delegate?.didFailClassification(error: .classificationFailed(error.localizedDescription))
            }
        }
    }
    
    func savePokemon(pokemonName: String) {
        CoreDataPokemonDataPersistence().savePokemonName(pokemonName)
    }
    
    private func processClassifications(for request: VNRequest, error: Error?) {
        if let error = error {
            delegate?.didFailClassification(error: .classificationFailed(error.localizedDescription))
            return
        }
        
        guard let results = request.results, let classifications = results as? [VNClassificationObservation] else {
            delegate?.didFailClassification(error: .classificationFailed(error?.localizedDescription ?? "Unknown error"))
            return
        }
        
        guard !classifications.isEmpty else {
            delegate?.didFailClassification(error: .nothingRecognized)
            return
        }
        
        let identifier = classifications.first?.identifier ?? ""
        let confidence = classifications.first?.confidence ?? 0.0
        
        delegate?.didFinishClassification(identifier: identifier, confidence: confidence)
    }
    
}
