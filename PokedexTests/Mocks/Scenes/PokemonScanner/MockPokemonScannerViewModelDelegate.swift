//
//  MockPokemonScannerViewModelDelegate.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 01/08/24.
//

import XCTest
@testable import Pokedex

class MockPokemonScannerViewModelDelegate: PokemonScannerViewModelDelegate {
    var expectation: XCTestExpectation?
    
    var didFinishClassificationCalled = false
    var classification: (identifier: String, confidence: Float)?
    
    var didFailClassificationCalled = false
    var error: PokemonScannerError?
    
    func didFinishClassification(identifier: String, confidence: Float) {
        didFinishClassificationCalled = true
        classification = (identifier, confidence)
        expectation?.fulfill()
    }
    
    func didFailClassification(error: PokemonScannerError) {
        didFailClassificationCalled = true
        self.error = error
        expectation?.fulfill()
    }
}
