//
//  PokemonServiceTests.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//

import XCTest
@testable import Pokedex

class PokemonServiceTests: XCTestCase {
    
    var sut: PokemonService!
    var mockClient: MockHTTPClient!
    var mockListMapper: MockPokemonListMapper!
    var mockDetailMapper: MockPokemonDetailMapper!
    
    override func setUp() {
        super.setUp()
        mockClient = MockHTTPClient()
        mockListMapper = MockPokemonListMapper()
        mockDetailMapper = MockPokemonDetailMapper()
        sut = PokemonService(client: mockClient, pokemonListMapper: mockListMapper, pokemonDetailMapper: mockDetailMapper)
    }
    
    override func tearDown() {
        sut = nil
        mockClient = nil
        mockListMapper = nil
        mockDetailMapper = nil
        super.tearDown()
    }
    
    func testFetchPokemonList_whenRequestIsSuccessful_shouldReturnPokemonList() {
        // Given
        let pokemonList = [Pokemon.getPikachuMock(), Pokemon.getBulbasaurMock()]
        mockListMapper.result = .success(pokemonList)
        let data = Data()
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockClient.result = .responseData(data: data, response: response)
        
        let expectation = self.expectation(description: "Completion handler called")
        
        // When
        sut.fetchPokemonList { result in
            // Then
            switch result {
            case .success(let fetchedPokemonList):
                XCTAssertEqual(fetchedPokemonList.count, pokemonList.count)
                XCTAssertEqual(fetchedPokemonList.first?.name, "Pikachu")
            case .failure:
                XCTFail("Expected success, got \(result) instead")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchPokemonList_whenRequestFails_shouldReturnError() {
        // Given
        mockListMapper.result = .failure(.serverError(status: 500))
        let error = MockError()
        mockClient.result = .requestFailed(error)
        
        let expectation = self.expectation(description: "Completion handler called")
        
        // When
        sut.fetchPokemonList { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure, got \(result) instead")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchPokemonDetail_whenRequestIsSuccessful_shouldReturnPokemonDetail() {
        // Given
        let pokemonDetail = PokemonDetail.getPikachuMock()
        mockDetailMapper.result = .success(pokemonDetail)
        let data = Data()
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockClient.result = .responseData(data: data, response: response)
        
        let expectation = self.expectation(description: "Completion handler called")
        
        // When
        sut.fetchPokemonDetail(with: "Pikachu") { result in
            // Then
            switch result {
            case .success(let fetchedPokemonDetail):
                XCTAssertEqual(fetchedPokemonDetail.name, "pikachu")
            case .failure:
                XCTFail("Expected success, got \(result) instead")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchPokemonDetail_whenRequestFails_shouldReturnError() {
        // Given
        mockDetailMapper.result = .failure(.serverError(status: 500))
        let error = MockError()
        mockClient.result = .requestFailed(error)
        
        let expectation = self.expectation(description: "Completion handler called")
        
        // When
        sut.fetchPokemonDetail(with: "Pikachu") { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure, got \(result) instead")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}

struct MockError: Error {}
