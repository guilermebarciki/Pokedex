//
//  MockPokemonListMapper.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//

@testable import Pokedex

final class MockPokemonListMapper: PokemonListMapperProtocol {
    var result: Result<[Pokemon], ApiError>?
    
    func map(result: NetworkResult) -> Result<[Pokemon], ApiError> {
        return self.result ?? .failure(.invalidRequest)
    }
}
