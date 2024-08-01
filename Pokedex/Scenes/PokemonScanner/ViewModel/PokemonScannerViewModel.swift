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
    func didFailClassification(errorMessage: String)
}

final class PokemonScannerViewModel {
    
    weak var delegate: PokemonScannerViewModelDelegate?
    
    init(delegate: PokemonScannerViewModelDelegate) {
        self.delegate = delegate
    }
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: PokemonClassifier2().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to Load Pokemon ML Model: \(error)")
        }
    }()
    
    func updateClassifications(for image: UIImage) {
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation!)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    private func processClassifications(for request: VNRequest, error: Error?) {
        guard
            let results = request.results,
            let classifications = results as? [VNClassificationObservation] else {
            delegate?.didFailClassification(errorMessage: "UNABLE TO CLASSIFY IMAGE \n \(error?.localizedDescription)")
            return
        }
        guard !classifications.isEmpty else {
            delegate?.didFailClassification(errorMessage: "NOTHING RECOGNIZED")
            return
        }
        
        let topClassifications = classifications.prefix(2)
        let descriptions = topClassifications.map { classification in
            return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
        }
        let description = (classifications.first!.identifier, classifications.first!.confidence)
        savePokemon(pokemonName: classifications.first!.identifier)
        delegate?.didFinishClassification(description)
        
    }
    
    private func savePokemon(pokemonName: String) {
        CoreDataPokemonDataPersistence().savePokemonName(pokemonName)
    }
}
