//
//  PokemonDetailProvider.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 30/07/24.
//

import Foundation

enum PokemonDetailEndpointProvider {
    case getPokemonDetail(name: String)
}

extension PokemonDetailEndpointProvider: ApiEndpoint {
    var baseUrlString: String {
        return "https://pokeapi.co"
    }

    var path: String {
        switch self {
        case .getPokemonDetail(let name):
            return "/api/v2/pokemon/\(name.lowercased())"
        }
    }
    
    var method: String {
        return "GET"
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
}
