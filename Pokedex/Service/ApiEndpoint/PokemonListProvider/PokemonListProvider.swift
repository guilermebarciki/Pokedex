//
//  PokemonListProvider.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

enum PokemonListProvider {
    case GetPokemonList
}

extension PokemonListProvider: ApiEndpoint {
    var method: String {
        "GET"
    }
    
    var urlString: String {
        return "https://pokeapi.co/api/v2/pokemon?offset=0&limit=151"
    }
}
