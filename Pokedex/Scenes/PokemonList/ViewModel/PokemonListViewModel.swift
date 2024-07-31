//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Guilerme Barciki on 29/07/24.
//

import Foundation

enum PresentationMode {
    case all
    case caught
}

protocol PokemonListDelegate: AnyObject {
    func didUpdatePokemonList()
}

typealias PokemonListNavigationData = Any

final class PokemonListViewModel {
    
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
    private var presentationMode: PresentationMode = .all
    
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
                self?.allPokemon = pokemonList
                self?.filterPokemon()
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
        
    }
    
    private func filterPokemon() {
        filteredPokemon = allPokemon
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
    
    func pokemon(at index: Int) -> Pokemon? {
        return filteredPokemon.safeFind(at: index)
    }
    
    func setPresentationStatus(index: Int) {
        presentationMode = index == 0 ? .all : .caught
    }
    
    func getPresentationStatus() -> PresentationMode {
        return presentationMode
    }
    
    func isPokemonCaught(index: Int) -> Bool {
        guard let pokemonName = allPokemon.safeFind(at: index)?.name else {
            return false
        }
        return caughtPokemons.contains(pokemonName)
    }
    
}

// MARK: - Navigation

extension PokemonListViewModel {
    func prepareForNavigation(with navigationData: PokemonListNavigationData) {}
}



