//
//  PokemonScannerError.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 01/08/24.
//

import Foundation

enum PokemonScannerError: Error {
    case modelLoadingFailed
    case classificationFailed(String)
    case imageProcessingFailed
    case nothingRecognized
    
    var localizedDescription: String {
        switch self {
        case .modelLoadingFailed:
            return "Failed to load Pokemon ML Model."
        case .classificationFailed(let message):
            return "Failed to classify image: \(message)"
        case .imageProcessingFailed:
            return "Unable to process image."
        case .nothingRecognized:
            return "No Pokémon recognized."
        }
    }
}
