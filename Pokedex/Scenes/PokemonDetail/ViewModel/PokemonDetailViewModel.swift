//  
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

protocol PokemonDetailDelegate: AnyObject {
    func didFetchPokemonDetail(_ detail: PokemonInfo)
    func didFail(errorMessage: String)
}

typealias PokemonDetailNavigationData = String

final class PokemonDetailViewModel {
    
    // MARK: - Properties
    
    private weak var delegate: PokemonDetailDelegate?
    private let service: PokemonServiceProtocol
    
    private let pokemonName: String
    
    // MARK: - Init
    
    init(pokemonName: String, service: PokemonServiceProtocol = PokemonService()) {
        self.pokemonName = pokemonName
        self.service = service
    }
    
    func setDelegate(delegate: PokemonDetailDelegate){
        self.delegate = delegate
    }
    
}

// MARK: - Fetch Methods

extension PokemonDetailViewModel {
    
    func fetchPokemonDetail() {
        service.fetchPokemonDetail(with: pokemonName) { [weak self] result in
            switch result {
            case .success(let pokemonDetail):
                self?.handleFetchedPokemonDetail(with: pokemonDetail)
            case .failure(let error):
                self?.delegate?.didFail(errorMessage: error.localizedDescription)
            }
        }
    }
}

// MARK: - Private Methods

extension PokemonDetailViewModel {
    
    func handleFetchedPokemonDetail(with pokemonDetail: PokemonDetail) {
        let pokemonInfo = PokemonInfo(pokemonDetail: pokemonDetail)
        delegate?.didFetchPokemonDetail(pokemonInfo)
    }
    
}
