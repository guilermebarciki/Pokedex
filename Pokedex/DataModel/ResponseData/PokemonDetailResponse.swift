//
//  PokemonDetailResponse.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 31/07/24.
//

import Foundation

struct PokemonDetailResponse: Decodable {
    let name: String
    let height: Int
    let weight: Int
    let types: [TypeElementResponse]
}

extension PokemonDetailResponse {
    
    func toDomainModel() -> PokemonDetail {
        let pokemonTypes = types.compactMap { PokemonType(rawValue: $0.type.name) }
        
        return PokemonDetail(
            name: name,
            height: height,
            weight: weight,
            types: pokemonTypes
        )
    }
    
}

struct TypeInfoResponse: Decodable {
    let name: String
}

struct TypeElementResponse: Decodable {
    let type: TypeInfoResponse
}
