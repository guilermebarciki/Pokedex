//
//  MockClassificationRequestProvider.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 01/08/24.
//

@testable import Pokedex
import Vision

class MockClassificationRequestProvider: ClassificationRequestProvider {
    var classificationRequest: VNCoreMLRequest?
    var shouldFailToCreateRequest = false
    
    func createClassificationRequest(completionHandler: @escaping (VNRequest, Error?) -> Void) -> VNCoreMLRequest? {
        if shouldFailToCreateRequest {
            return nil
        } else {
            return classificationRequest
        }
    }
}

@testable import Pokedex
//import Vision

import UIKit
import CoreImage

class MockImageProcessor: ImageProcessor {
    var ciImage: CIImage?
    var orientation: CGImagePropertyOrientation = .up
    
    func createCIImage(from image: UIImage) -> CIImage? {
        return ciImage
    }
    
    func getCGImagePropertyOrientation(from image: UIImage) -> CGImagePropertyOrientation {
        return orientation
    }
}



import Vision

import Vision

class MockImageRequestHandler: ImageRequestHandler {
    var shouldThrowError = false
    var testResults: [VNClassificationObservation] = [VNClassificationObservation.makeMockObservation(identifier: "Pikachu", confidence: 0.95)]
    
    func perform(_ requests: [VNRequest]) -> Result<[VNRequest], Error> {
        if shouldThrowError {
            return .failure(NSError(domain: "test", code: 1, userInfo: nil))
        }
        for request in requests {
            (request as? VNCoreMLRequest)?.setValue(testResults, forKey: "results")
        }
        return .success(requests)
    }
}


class MockImageRequestHandlerFactory: ImageRequestHandlerFactory {
    var mockRequestHandler: MockImageRequestHandler?
    
    func makeImageRequestHandler(ciImage: CIImage, orientation: CGImagePropertyOrientation) -> ImageRequestHandler {
        return mockRequestHandler ?? MockImageRequestHandler()
    }
}


extension VNClassificationObservation {
    static func makeMockObservation(identifier: String, confidence: VNConfidence) -> VNClassificationObservation {
        let observation = VNClassificationObservation()
        observation.setValue(identifier, forKey: "identifier")
        observation.setValue(confidence, forKey: "confidence")
        return observation
    }
}
