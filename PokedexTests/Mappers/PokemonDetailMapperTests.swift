//
//  PokemonDetailMapperTests.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//

import XCTest
@testable import Pokedex

final class PokemonDetailMapperTests: XCTestCase {
    
    var mapper: PokemonDetailMapper!
    var mockHttpRequestMapper: MockHttpRequestMapper!
    
    override func setUp() {
        super.setUp()
        mockHttpRequestMapper = MockHttpRequestMapper()
        mapper = PokemonDetailMapper(mapper: mockHttpRequestMapper)
    }
    
    override func tearDown() {
        mapper = nil
        mockHttpRequestMapper = nil
        super.tearDown()
    }
    
    func testMap_whenNetworkResultIsSuccessful_shouldReturnPokemonDetail() {
        // Given
        let pokemonDetailResponse = PokemonDetailResponse(
            name: "Pikachu",
            height: 4,
            weight: 60,
            id: 25,
            types: [TypeElementResponse(type: TypeInfoResponse(name: "electric"))]
        )
        mockHttpRequestMapper.mockResult = Result<PokemonDetailResponse, ApiError>.success(pokemonDetailResponse)
        
        // When
        let result = mapper.map(result: .responseData(data: Data(), response: HTTPURLResponse()))
        
        // Then
        switch result {
        case .success(let pokemonDetail):
            XCTAssertEqual(pokemonDetail.name, "Pikachu")
            XCTAssertEqual(pokemonDetail.height, 0.4)
            XCTAssertEqual(pokemonDetail.weight, 6.0)
            XCTAssertEqual(pokemonDetail.types.first, .electric)
        case .failure:
            XCTFail("Expected success, got \(result) instead")
        }
    }
    
    func testMap_whenNetworkResultFails_shouldReturnError() {
        // Given
        mockHttpRequestMapper.mockResult = Result<PokemonDetailResponse, ApiError>.failure(.serverError(status: 500))
        
        // When
        let result = mapper.map(result: .responseData(data: Data(), response: HTTPURLResponse()))
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure, got \(result) instead")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }
}
