//  
//  PokemonDetailRouter.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import UIKit

final class PokemonDetailRouter {
    
    
    // MARK: - Properties
    
    private var navigationController: UINavigationController
    
    
    // MARK: - Init
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}


// MARK: - Self Navigation

extension PokemonDetailRouter {
    
    func navigate(with navigationData: PokemonDetailNavigationData, customAnimation: Bool = true, animated: Bool = true, completion: (() -> Void)? = nil) {
        
        let viewController = PokemonDetailFactory.make(with: navigationData)
        navigationController.pushViewController(viewController, animated: animated)
    }
    
}

// MARK: - External navigation

extension PokemonDetailRouter {}
