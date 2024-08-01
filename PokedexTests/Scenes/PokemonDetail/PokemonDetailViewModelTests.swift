//
//  PokemonDetailViewModelTests.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//

import XCTest
@testable import Pokedex

import XCTest
@testable import Pokedex

final class PokemonDetailViewModelTests: XCTestCase {
    
    var sut: PokemonDetailViewModel!
    var mockService: MockPokemonService!
    var mockDelegate: MockPokemonDetailDelegate!
    
    override func setUp() {
        super.setUp()
        mockService = MockPokemonService()
        mockDelegate = MockPokemonDetailDelegate()
        sut = PokemonDetailViewModel(pokemonName: "Pikachu", service: mockService)
        sut.setDelegate(delegate: mockDelegate)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testFetchPokemonDetail_whenServiceReturnsSuccess_shouldCallDidFetchPokemonDetail() {
        // given
        let pokemonDetail = PokemonDetail.getPikachuMock()
        mockService.fetchPokemonDetailResult = .success(pokemonDetail)
        
        // when
        sut.fetchPokemonDetail()
        
        // then
        XCTAssertTrue(mockDelegate.didFetchPokemonDetailCalled)
        XCTAssertEqual(mockDelegate.fetchedPokemonDetail?.id, 25)
        XCTAssertEqual(mockDelegate.fetchedPokemonDetail?.name, "Pikachu")
        XCTAssertEqual(mockDelegate.fetchedPokemonDetail?.height, 0.4.formattedHeight())
        XCTAssertEqual(mockDelegate.fetchedPokemonDetail?.weight, 6.0.formattedWeight())
        XCTAssertEqual(mockDelegate.fetchedPokemonDetail?.types, [.electric])
        XCTAssertEqual(mockDelegate.fetchedPokemonDetail?.imageUrl, "pikachu_image")
    }
    
    func testFetchPokemonDetail_whenServiceReturnsFailure_shouldCallDidFail() {
        // given
        mockService.fetchPokemonDetailResult = .failure(.serverError(status: 500))
        
        // when
        sut.fetchPokemonDetail()
        
        // then
        XCTAssertTrue(mockDelegate.didFailCalled)
    }
}
