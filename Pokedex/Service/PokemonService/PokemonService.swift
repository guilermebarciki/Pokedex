//
//  PokemonService.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

typealias FetchPokemonListResult = Result<[Pokemon], ApiError>
typealias FetchPokemonDetailResult = Result<PokemonDetailResponse, ApiError>

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
        
        guard let request = PokemonListEndpointProvider.getPokemonList.makeRequest else {
            completion(.failure(.invalidRequest))
            return
        }
        
        client.perform(request: request) { [mapper] result in
            completion(mapper.map(result: result))
        }
    }
    
    func fetchPokemonDetail(with name: String, completion: @escaping (FetchPokemonDetailResult) -> Void) {
        guard let request = PokemonDetailEndpointProvider.getPokemonDetail(name: name).makeRequest else {
            completion(.failure(.invalidRequest))
            return
        }
        
        client.perform(request: request) { result in
            let mappedResult: Result<PokemonDetailResponse,ApiError> = HttpRequestMaper().map(result: result)
            completion(mappedResult)
        }
    }
    
}
