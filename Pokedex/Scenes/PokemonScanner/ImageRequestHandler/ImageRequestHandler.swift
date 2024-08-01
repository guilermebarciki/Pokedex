//
//  ImageRequestHandler.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 01/08/24.
//

import Vision
import CoreImage

protocol ImageRequestHandler {
    func perform(_ requests: [VNRequest]) throws
}

class VisionImageRequestHandler: ImageRequestHandler {
    private let handler: VNImageRequestHandler
    
    init(ciImage: CIImage, orientation: CGImagePropertyOrientation) {
        self.handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
    }
    
    func perform(_ requests: [VNRequest]) throws {
        try handler.perform(requests)
    }
}
