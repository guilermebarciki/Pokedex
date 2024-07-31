//
//  MockPokemonService.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//

@testable import Pokedex

class MockPokemonService: PokemonServiceProtocol {
    
    func fetchPokemonDetail(with name: String, completion: @escaping (Pokedex.FetchPokemonDetailResult) -> Void) {
        
    }
    
    var fetchPokemonListResult: FetchPokemonListResult?
    
    func fetchPokemonList(completion: @escaping (FetchPokemonListResult) -> Void) {
        if let result = fetchPokemonListResult {
            completion(result)
        }
    }
}
