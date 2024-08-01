//
//  ClassificationProvider.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 01/08/24.
//

import CoreML
import Vision

protocol ClassificationRequestProvider {
    func createClassificationRequest(completionHandler: @escaping (VNRequest, Error?) -> Void) -> VNCoreMLRequest?
}

class MLModelRequestProvider: ClassificationRequestProvider {
    private let model: VNCoreMLModel
    
    init(modelName: String = "PokemonClassifier2") {
        guard let model = try? VNCoreMLModel(for: PokemonClassifier2().model) else {
            fatalError("Failed to load model")
        }
        self.model = model
    }
    
    func createClassificationRequest(completionHandler: @escaping (VNRequest, Error?) -> Void) -> VNCoreMLRequest? {
        let request = VNCoreMLRequest(model: model, completionHandler: completionHandler)
        request.imageCropAndScaleOption = .centerCrop
        return request
    }
}
