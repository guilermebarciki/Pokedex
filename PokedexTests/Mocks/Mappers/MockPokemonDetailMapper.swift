//
//  MockPokemonDetailMapper.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//

@testable import Pokedex

final class MockPokemonDetailMapper: PokemonDetailMapperProtocol {
    var result: Result<PokemonDetail, ApiError>?
    
    func map(result: NetworkResult) -> Result<PokemonDetail, ApiError> {
        return self.result ?? .failure(.invalidRequest)
    }
}
