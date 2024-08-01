//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 01/08/24.
//

import Foundation

struct PokemonInfo {
    let id: Int
    let name: String
    let height: String
    let weight: String
    let types: [PokemonType]
    let imageUrl: String
    
    init(pokemonDetail: PokemonDetail) {
        self.id = pokemonDetail.id
        self.name = pokemonDetail.name.capitalized
        self.height = pokemonDetail.height.formattedHeight()
        self.weight = pokemonDetail.weight.formattedWeight()
        self.types = pokemonDetail.types
        self.imageUrl = pokemonDetail.imageUrl
    }
}
