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
    func didFinishClassification(_ classification: (String, Float))
    func didFailClassification(error: PokemonScannerError)
}

final class PokemonScannerViewModel {
    
    private let requestProvider: ClassificationRequestProvider
    
    weak var delegate: PokemonScannerViewModelDelegate?
    
    init(delegate: PokemonScannerViewModelDelegate, requestProvider: ClassificationRequestProvider = MLModelRequestProvider()) {
        self.delegate = delegate
        self.requestProvider = requestProvider
    }
    
    func updateClassifications(for image: UIImage) {
        guard let classificationRequest = requestProvider.createClassificationRequest(completionHandler: processClassifications) else {
            delegate?.didFailClassification(error: .modelLoadingFailed)
            return
        }
        
        guard
            let ciImage = CIImage(image: image),
            let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))else {
            delegate?.didFailClassification(error: .imageProcessingFailed)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([classificationRequest])
            } catch {
                self.delegate?.didFailClassification(error: .classificationFailed(error.localizedDescription))
            }
        }
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
        
        let topClassifications = classifications.prefix(2)
        let identifier = classifications.first?.identifier ?? ""
        let confidence = classifications.first?.confidence ?? 0.0
        let description = (identifier, confidence)
        
        savePokemon(pokemonName: identifier)
        delegate?.didFinishClassification(description)
    }
    
    private func savePokemon(pokemonName: String) {
        CoreDataPokemonDataPersistence().savePokemonName(pokemonName)
    }
}
