//  
//  PokemonScannerRouter.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 30/07/24.
//

import UIKit

final class PokemonScannerRouter {
    
    
    // MARK: - Properties
    
    private var navigationController: UINavigationController
    
    
    // MARK: - Init
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}


// MARK: - Self Navigation

extension PokemonScannerRouter {
    
    func navigate(customAnimation: Bool = true, navigationType: NavigationType = .push, animated: Bool = true, completion: (() -> Void)? = nil) {
        
        let viewController = PokemonScannerViewController()
        
        if navigationType == .push {
            navigationController.pushViewController(viewController, animated: animated)
        } else {
            navigationController.present(viewController, animated: animated, completion: completion)
        }
    }
    
}

// MARK: - External navigation

extension PokemonScannerRouter {}
