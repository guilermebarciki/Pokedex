//
//  PokemonResponse.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 30/07/24.
//

import Foundation

struct PokemonResponse: Decodable {
    let name: String
    let url: String
}

extension PokemonResponse {
    
    func toDomainModel() -> Pokemon {
        let number = url.extractPokemonNumber() ?? 0
        let pokemonImage = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(number).png"
         return Pokemon(
            name: name.capitalized,
            url: url,
            number: url.extractPokemonNumber() ?? 0,
            pokemonImage: pokemonImage
        )
    }
    
}

