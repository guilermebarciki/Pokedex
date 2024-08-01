//
//  PokemonScannerError.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 01/08/24.
//

import Foundation

enum PokemonScannerError: Error, Equatable {
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
    
    static func ==(lhs: PokemonScannerError, rhs: PokemonScannerError) -> Bool {
            switch (lhs, rhs) {
            case (.modelLoadingFailed, .modelLoadingFailed),
                 (.imageProcessingFailed, .imageProcessingFailed),
                 (.nothingRecognized, .nothingRecognized):
                return true
            case (.classificationFailed(let lhsMessage), .classificationFailed(let rhsMessage)):
                return lhsMessage == rhsMessage
            default:
                return false
            }
        }
}
