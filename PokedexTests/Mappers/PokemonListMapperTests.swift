//
//  PokemonListMapperTests.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//

import XCTest
@testable import Pokedex

final class PokemonListMapperTests: XCTestCase {
    
    var mapper: PokemonListMapper!
    var mockHttpRequestMapper: MockHttpRequestMapper!
    
    override func setUp() {
        super.setUp()
        mockHttpRequestMapper = MockHttpRequestMapper()
        mapper = PokemonListMapper(mapper: mockHttpRequestMapper)
    }
    
    override func tearDown() {
        mapper = nil
        mockHttpRequestMapper = nil
        super.tearDown()
    }
    
    func testMap_whenNetworkResultIsSuccessful_shouldReturnPokemonList() {
        // Given
        let pokemonListResponse = PokemonListResponse(results: [PokemonResponse(name: "Pikachu", url: "https://example.com/pikachu")])
        mockHttpRequestMapper.mockResult = Result<PokemonListResponse, ApiError>.success(pokemonListResponse)
        
        // When
        let result = mapper.map(result: .responseData(data: Data(), response: HTTPURLResponse()))
        
        // Then
        switch result {
        case .success(let pokemonList):
            XCTAssertEqual(pokemonList.count, 1)
            XCTAssertEqual(pokemonList.first?.name, "Pikachu")
        case .failure:
            XCTFail("Expected success, got \(result) instead")
        }
    }
    
    func testMap_whenNetworkResultFails_shouldReturnError() {
        // Given
        mockHttpRequestMapper.mockResult = Result<PokemonListResponse, ApiError>.failure(.serverError(status: 500))
        
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

