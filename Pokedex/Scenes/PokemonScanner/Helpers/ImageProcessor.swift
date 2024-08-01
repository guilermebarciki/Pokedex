//
//  ImageProcessor.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 01/08/24.
//

import UIKit
import CoreImage

protocol ImageProcessor {
    func createCIImage(from image: UIImage) -> CIImage?
    func getCGImagePropertyOrientation(from image: UIImage) -> CGImagePropertyOrientation
}

class DefaultImageProcessor: ImageProcessor {
    func createCIImage(from image: UIImage) -> CIImage? {
        return CIImage(image: image)
    }
    
    func getCGImagePropertyOrientation(from image: UIImage) -> CGImagePropertyOrientation {
        return CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)) ?? .up
    }
}
