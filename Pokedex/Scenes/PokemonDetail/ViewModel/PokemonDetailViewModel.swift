//  
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

protocol PokemonDetailDelegate: AnyObject {
    func didFetchPokemonDetail(_ detail: PokemonDetail)
    func didFail(errorMessage: String)
}

typealias PokemonDetailNavigationData = String

final class PokemonDetailViewModel {
    
    // MARK: - Properties
    
    private weak var delegate: PokemonDetailDelegate?
    let pokemonName: String
    
    // MARK: - Init
    
    init(pokemonName: String) {
        self.pokemonName = pokemonName
    }
    
    func setDelegate(delegate: PokemonDetailDelegate){
        self.delegate = delegate
    }
    
}

// MARK: - Fetch Methods

extension PokemonDetailViewModel {
    
    func fetchPokemonDetail() {
        PokemonService().fetchPokemonDetail(with: pokemonName) { [weak self] result in
            switch result {
            case .success(let pokemonDetail):
                self?.delegate?.didFetchPokemonDetail(pokemonDetail)
            case .failure(let error):
                self?.delegate?.didFail(errorMessage: error.localizedDescription)
            }
        }
    }
}
