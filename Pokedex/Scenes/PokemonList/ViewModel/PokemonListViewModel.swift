//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Guilerme Barciki on 29/07/24.
//

import Foundation

protocol PokemonListDelegate: AnyObject {
    func didUpdatePokemonList()
}

typealias PokemonListNavigationData = Any

class PokemonListViewModel {
    
    // MARK: - Properties
    
    weak var delegate: PokemonListDelegate?
    
    private let service: PokemonServiceProtocol
    
    private var allPokemon: [Pokemon] = []
    private var filteredPokemon: [Pokemon] = []
    private var searchQuery: String = "" {
        didSet {
            filterPokemon()
        }
    }
    
    // MARK: - Init
    
    init(delegate: PokemonListDelegate?, service: PokemonServiceProtocol = PokemonService()) {
        self.delegate = delegate
        self.service = service
    }
    
    // MARK: - Fetch Methods
    
    func fetchAllPokemon() {
        
        service.fetchPokemonList { [weak self] result in
            switch result {
            case .success(let pokemonList):
                self?.allPokemon = pokemonList.results
                self?.filterPokemon()
            case .failure(let error):
                fatalError()
            }
        }
        
    }
    
    private func filterPokemon() {
        if searchQuery.isEmpty {
            filteredPokemon = allPokemon
        } else {
            filteredPokemon = allPokemon.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        }
        delegate?.didUpdatePokemonList()
    }
    
    // MARK: - Public Methods
    
    func updateSearchQuery(_ query: String) {
        searchQuery = query
    }
    
    func pokemonCount() -> Int {
        return filteredPokemon.count
    }
    
    func pokemon(at index: Int) -> Pokemon {
        return filteredPokemon[index]
    }
    
}

// MARK: - Navigation

extension PokemonListViewModel {
    func prepareForNavigation(with navigationData: PokemonListNavigationData) {}
}

// MARK: - Pokemon Model

struct PokemonListResult: Decodable {
    let results: [Pokemon]
}

struct Pokemon: Decodable {
    let name: String
}
