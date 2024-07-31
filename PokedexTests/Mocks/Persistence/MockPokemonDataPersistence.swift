//
//  MockPokemonDataPersistence.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//

@testable import Pokedex

class MockPokemonDataPersistence: PokemonDataPersistence {
    private var savedPokemonNames: Set<String> = []
    
    func savePokemonName(_ name: String) {
        savedPokemonNames.insert(name)
    }
    
    func isPokemonNameSaved(_ name: String) -> Bool {
        return savedPokemonNames.contains(name)
    }
}
