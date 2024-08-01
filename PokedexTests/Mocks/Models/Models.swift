//
//  Models.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//

@testable import Pokedex

extension PokemonDetail {
    
    static func getPikachuMock() -> PokemonDetail {
        PokemonDetail(
            id: 25,
            name: "pikachu",
            height: 0.4,
            weight: 6.0,
            types: [.electric],
            imageUrl: "pikachu_image"
        )
    }

}

extension Pokemon {
    
    static func getPikachuMock() -> Pokemon {
        Pokemon(name: "Pikachu", number: 1, pokemonImage: "Pikachu")
    }
    
    static func getBulbasaurMock() -> Pokemon {
        Pokemon(name: "Bulbasaur", number: 1, pokemonImage: "Bulbasaur")
    }
    
    static func getCharmanderMock() -> Pokemon {
        Pokemon(name: "Charmander", number: 1, pokemonImage: "Charmander")
    }
}
