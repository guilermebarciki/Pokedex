//  
//  PokemonListRouter.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import UIKit

final class PokemonListRouter {
    
    
    // MARK: - Properties
    
    private var navigationController: UINavigationController
    
    
    // MARK: - Init
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}


// MARK: - Self Navigation

extension PokemonListRouter {
    
    func navigate(with navigationData: PokemonListNavigationData, customAnimation: Bool = true, animated: Bool = true, completion: (() -> Void)? = nil) {
        
        let viewController = PokemonListViewController()
        viewController.prepareForNavigation(with: navigationData)
        navigationController.pushViewController(viewController, animated: animated)
    }
    
}

// MARK: - External navigation

extension PokemonListRouter {
    
    func navigateToPokemonDetail() {
        let pokemonDetail = PokemonDetailViewController()
        navigationController.pushViewController(pokemonDetail, animated: true)
    }
    
}
