//
//  PokemonService.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

typealias FetchPokemonListResult = Result<[Pokemon], ApiError>

protocol PokemonServiceProtocol {
    func fetchPokemonList(completion: @escaping (FetchPokemonListResult) -> Void)
}

final class PokemonService: PokemonServiceProtocol {
    let client: HTTPClient
    let mapper: PokemonListMapper
    
    init(client: HTTPClient = URLSession.shared, mapper: PokemonListMapper = PokemonListMapper()) {
        self.client = client
        self.mapper = mapper
    }
    
    func fetchPokemonList(completion: @escaping (FetchPokemonListResult) -> Void) {
        
        guard let request = PokemonListProvider.GetPokemonList.makeRequest else {
            completion(.failure(.invalidRequest))
            return
        }
        
        client.perform(request: request) { [mapper] result in
            completion(mapper.map(result: result))
        }
    }
    
}
