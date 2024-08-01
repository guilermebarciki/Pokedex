//
//  PokemonListProvider.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

enum PokemonListEndpointProvider {
    case getPokemonList
}

extension PokemonListEndpointProvider: ApiEndpoint {
    var baseUrlString: String {
        return "https://pokeapi.co"
    }
    
    var path: String {
        switch self {
        case .getPokemonList:
            return "/api/v2/pokemon"
        }
    }
    
    var method: String {
        return "GET"
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getPokemonList:
            return [URLQueryItem(name: "offset", value: "0"), URLQueryItem(name: "limit", value: "151")]
        }
    }
}
