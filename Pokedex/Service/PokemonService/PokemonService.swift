//
//  PokemonService.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

typealias FetchPokemonListResult = Result<PokemonListResult, ApiError>

protocol PokemonServiceProtocol {
    func fetchPokemonList(completion: @escaping (FetchPokemonListResult) -> Void)
}

class PokemonService: PokemonServiceProtocol {
    let client: HTTPClient
    
    init(client: HTTPClient = URLSession.shared) {
        self.client = client
    }
    
    func fetchPokemonList(completion: @escaping (FetchPokemonListResult) -> Void) {
        
        guard let request = PokemonListProvider.GetPokemonList.makeRequest else {
            completion(.failure(.invalidRequest))
            return
        }
        
        client.perform(request: request) { result in
            let mappedResult: FetchPokemonListResult = GenericHttpRequestMaper.map(result: result)
            completion(mappedResult)
        }
    }
    
}
