//
//  MockPokemonListDelegate.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//

@testable import Pokedex

class MockPokemonListDelegate: PokemonListDelegate {
    var didUpdatePokemonListCalled = false
    var didFailCalled = false
    
    func didUpdatePokemonList() {
        didUpdatePokemonListCalled = true
    }
    
    func didFail(errorMessage: String){
        didFailCalled = true
    }
    
}
