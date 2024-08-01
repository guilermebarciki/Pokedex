//
//  PokemonListResponse.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 30/07/24.
//

import Foundation

struct PokemonListResponse: Decodable {
    let results: [PokemonResponse]
}
