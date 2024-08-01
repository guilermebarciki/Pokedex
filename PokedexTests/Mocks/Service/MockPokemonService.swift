//
//  MockPokemonService.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//

@testable import Pokedex

class MockPokemonService: PokemonServiceProtocol {
    
    var fetchPokemonListResult: FetchPokemonListResult?
    var fetchPokemonDetailResult: FetchPokemonDetailResult?
    
    func fetchPokemonList(completion: @escaping (FetchPokemonListResult) -> Void) {
        if let result = fetchPokemonListResult {
            completion(result)
        }
    }
    
    func fetchPokemonDetail(with name: String, completion: @escaping (Pokedex.FetchPokemonDetailResult) -> Void) {
        if let result = fetchPokemonDetailResult {
            completion(result)
        }
    }
    
}
