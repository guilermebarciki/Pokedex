//
//  ImageRequestHandler.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 01/08/24.
//

import Vision
import CoreImage

protocol ImageRequestHandler {
    func perform(_ requests: [VNRequest]) -> Result<[VNRequest], Error>
}

class VisionImageRequestHandler: ImageRequestHandler {
    private let handler: VNImageRequestHandler
    
    init(ciImage: CIImage, orientation: CGImagePropertyOrientation) {
        self.handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
    }
    
    func perform(_ requests: [VNRequest]) -> Result<[VNRequest], Error> {
        do {
            try handler.perform(requests)
            return .success(requests)
        } catch {
            return .failure(error)
        }
    }
}
