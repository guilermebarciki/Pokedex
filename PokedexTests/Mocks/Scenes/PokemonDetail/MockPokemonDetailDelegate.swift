//
//  MockPokemonDetailDelegate.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//

@testable import Pokedex

class MockPokemonDetailDelegate: PokemonDetailDelegate {
    var didFetchPokemonDetailCalled = false
    var fetchedPokemonDetail: PokemonInfo?
    var didFailCalled = false
    var errorMessage: String?
    
    func didFetchPokemonDetail(_ detail: PokemonInfo) {
        didFetchPokemonDetailCalled = true
        fetchedPokemonDetail = detail
    }
    
    func didFail(errorMessage: String) {
        didFailCalled = true
        self.errorMessage = errorMessage
    }
}
