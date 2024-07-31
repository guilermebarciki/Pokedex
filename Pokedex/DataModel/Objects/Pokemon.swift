//
//  Pokemon.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 30/07/24.
//

import Foundation

struct Pokemon {
    let name: String
    let url: String
    let number: Int
    let pokemonImage: String
}


struct PokemonDetailResponse: Codable {
    let name: String
    let baseExperience: Int
    let height: Int
    let weight: Int
    let sprites: Sprites
    let types: [TypeElement]
    let abilities: [AbilityEntry]
    
    enum CodingKeys: String, CodingKey {
        case name
        case baseExperience = "base_experience"
        case height, weight, sprites, types, abilities
    }
}

struct AbilityEntry: Codable {
    let ability: NamedAPIResource
    let isHidden: Bool
    
    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
    }
}

struct NamedAPIResource: Codable {
    let name: String
    let url: String
}

struct Sprites: Codable {
    let frontDefault: String?
    let frontShiny: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

struct TypeElement: Codable {
    let type: NamedAPIResource
}
