//
//  PokemonListViewModelTests.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//

import XCTest
@testable import Pokedex

import XCTest
@testable import Pokedex

final class PokemonListViewModelTests: XCTestCase {
    
    var viewModel: PokemonListViewModel!
    var mockService: MockPokemonService!
    var mockDataPersistence: MockPokemonDataPersistence!
    var mockDelegate: MockPokemonListDelegate!
    
    override func setUp() {
        super.setUp()
        mockService = MockPokemonService()
        mockDataPersistence = MockPokemonDataPersistence()
        mockDelegate = MockPokemonListDelegate()
        viewModel = PokemonListViewModel(delegate: mockDelegate, service: mockService, dataPersistence: mockDataPersistence)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        mockDataPersistence = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testFetchAllPokemon_whenNetworkResponseIsSuccessful_shouldUpdatePokemonList() {
        // given
        let pokemonList = [
            Pokemon.getPikachuMock(),
            Pokemon.getBulbasaurMock()
        ]
        mockService.fetchPokemonListResult = .success(pokemonList)
        
        // when
        viewModel.fetchAllPokemon()
        
        // then
        XCTAssertEqual(viewModel.pokemonCount(), pokemonList.count)
        XCTAssertTrue(mockDelegate.didUpdatePokemonListCalled)
    }
    
    func testFetchAllPokemon_whenNetworkResponseFails_shouldHandleError() {
        // given
        mockService.fetchPokemonListResult = .failure(.serverError(status: 500))
        
        // when
        viewModel.fetchAllPokemon()
        
        // then
        XCTAssertTrue(mockDelegate.didFailCalled)
        
    }
    
    func testUpdateSearchQuery_whenSearchQueryIsUpdated_shouldFilterPokemon() {
        // given
        let pokemonList = [Pokemon.getPikachuMock(), Pokemon.getBulbasaurMock(), Pokemon.getCharmanderMock()]
        mockService.fetchPokemonListResult = .success(pokemonList)
        viewModel.fetchAllPokemon()
        
        // when
        viewModel.updateSearchQuery("char")
        
        // then
        XCTAssertEqual(viewModel.pokemonCount(), 1)
        XCTAssertEqual(viewModel.pokemon(at: 0)?.name, "Charmander")
    }
    
    func testSetPresentationStatus_whenIndexIsSet_shouldUpdatePresentationMode() {
        // given
        let index = 1
        
        // when
        viewModel.setPresentationStatus(index: index)
        
        // then
        XCTAssertEqual(viewModel.getPresentationStatus(), .caught)
    }
    
    func testIsPokemonCaught_whenPokemonIsSaved_shouldReturnTrue() {
        // given
        let pokemonList = [Pokemon.getPikachuMock(), Pokemon.getBulbasaurMock()]
        mockService.fetchPokemonListResult = .success(pokemonList)
        viewModel.fetchAllPokemon()
        mockDataPersistence.savePokemonName("Pikachu")
        
        // when
        let isCaught = viewModel.isPokemonCaught(index: 0)
        
        // then
        XCTAssertTrue(isCaught)
    }
}


