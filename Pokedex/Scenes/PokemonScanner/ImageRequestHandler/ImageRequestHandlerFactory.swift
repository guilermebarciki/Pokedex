//
//  ImageRequestHandlerFactory.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 01/08/24.
//

import Vision
import CoreImage

protocol ImageRequestHandlerFactory {
    func makeImageRequestHandler(ciImage: CIImage, orientation: CGImagePropertyOrientation) -> ImageRequestHandler
}

class VisionImageRequestHandlerFactory: ImageRequestHandlerFactory {
    func makeImageRequestHandler(ciImage: CIImage, orientation: CGImagePropertyOrientation) -> ImageRequestHandler {
        return VisionImageRequestHandler(ciImage: ciImage, orientation: orientation)
    }
}
