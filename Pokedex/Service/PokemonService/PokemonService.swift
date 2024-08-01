//
//  PokemonService.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

typealias FetchPokemonListResult = Result<[Pokemon], ApiError>
typealias FetchPokemonDetailResult = Result<PokemonDetail, ApiError>

protocol PokemonServiceProtocol {
    func fetchPokemonList(completion: @escaping (FetchPokemonListResult) -> Void)
    func fetchPokemonDetail(with name: String, completion: @escaping (FetchPokemonDetailResult) -> Void)
}

final class PokemonService: PokemonServiceProtocol {
    let client: HTTPClient
    let pokemonListMapper: PokemonListMapperProtocol
    let pokemonDetailMapper: PokemonDetailMapperProtocol
    
    init(
        client: HTTPClient = URLSession.shared,
        pokemonListMapper: PokemonListMapperProtocol = PokemonListMapper(),
        pokemonDetailMapper: PokemonDetailMapperProtocol = PokemonDetailMapper()
    ) {
        self.client = client
        self.pokemonListMapper = pokemonListMapper
        self.pokemonDetailMapper = pokemonDetailMapper
    }
    
    func fetchPokemonList(completion: @escaping (FetchPokemonListResult) -> Void) {
        
        guard let request = PokemonListEndpointProvider.getPokemonList.makeRequest else {
            completion(.failure(.invalidRequest))
            return
        }
        
        client.perform(request: request) { [pokemonListMapper] result in
            completion(pokemonListMapper.map(result: result))
        }
    }
    
    func fetchPokemonDetail(with name: String, completion: @escaping (FetchPokemonDetailResult) -> Void) {
        guard let request = PokemonDetailEndpointProvider.getPokemonDetail(name: name).makeRequest else {
            completion(.failure(.invalidRequest))
            return
        }
        
        client.perform(request: request) { [pokemonDetailMapper] result in
            let mappedResult = pokemonDetailMapper.map(result: result)
            completion(mappedResult)
        }
    }
    
}
