//
//  PokemonListMapper.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

protocol PokemonListMapperProtocol {
    func map(result: NetworkResult) -> Result<[Pokemon], ApiError>
}

struct PokemonListMapper: PokemonListMapperProtocol {
    private let mapper: HttpRequestMapperProtocol
    
    init(mapper: HttpRequestMapperProtocol = HttpRequestMaper()) {
        self.mapper = mapper
    }
    
    func map(result: NetworkResult) -> Result<[Pokemon], ApiError> {
        let mappedResult: Result<PokemonListResponse, ApiError> = mapper.map(result: result)
        
        switch mappedResult {
        case .success(let pokemonResult):
            return .success(pokemonResult.results.map{ $0.toDomainModel() })
        case .failure(let error):
            return .failure(error)
        }
    }
}




protocol PokemonDetailMapperProtocol {
    func map(result: NetworkResult) -> Result<PokemonDetail, ApiError>
}

struct PokemonDetailMapper: PokemonDetailMapperProtocol {
    private let mapper: HttpRequestMapperProtocol
    
    init(mapper: HttpRequestMapperProtocol = HttpRequestMaper()) {
        self.mapper = mapper
    }
    
    func map(result: NetworkResult) -> Result<PokemonDetail, ApiError> {
        let mappedResult: Result<PokemonDetailResponse, ApiError> = mapper.map(result: result)
        
        switch mappedResult {
        case .success(let pokemonResult):
            return .success(pokemonResult.toDomainModel())
        case .failure(let error):
            return .failure(error)
        }
    }
}
