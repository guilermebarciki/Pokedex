//  
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

protocol PokemonDetailDelegate: AnyObject {
    func didFetchPokemonDetail(_ detail: PokemonDetail)
}

typealias PokemonDetailNavigationData = String

final class PokemonDetailViewModel {
    
    // MARK: - Properties
    
    weak var delegate: PokemonDetailDelegate?
    
    // MARK: - Init
    
    init(delegate: PokemonDetailDelegate?) {
        self.delegate = delegate
    }
}

// MARK: - Navigation

extension PokemonDetailViewModel {
    
    func prepareForNavigation(with pokemonName: PokemonDetailNavigationData) {
        fetchPokemonDetail(with: pokemonName)
    }
}

// MARK: - Fetch Methods

extension PokemonDetailViewModel {
    
    func fetchPokemonDetail(with name: String) {
        PokemonService().fetchPokemonDetail(with: name) { [weak self] result in
            switch result {
            case .success(let pokemonDetail):
                self?.delegate?.didFetchPokemonDetail(pokemonDetail)
            case .failure(let error):
                print("Failed to fetch Pokémon details: \(error)")
            }
        }
    }
}
