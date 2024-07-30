//
//  PokemonListMapper.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

struct PokemonListMapper {
    private let mapper: HttpRequestMapperProtocol
    
    init(mapper: HttpRequestMapperProtocol = HttpRequestMaper()) {
        self.mapper = mapper
    }
    
    func map(result: NetworkResult) -> Result<[Pokemon], ApiError> {
        let mappedResult: Result<PokemonListResponse, ApiError> = mapper.map(result: result)
        
        switch mappedResult {
        case .success(let pokemonResult):
            return .success(pokemonResult.results)
        case .failure(let error):
            return .failure(error)
        }
    }
}
