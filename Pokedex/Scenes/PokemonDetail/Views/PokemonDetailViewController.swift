//  
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import UIKit

final class PokemonDetailViewController: UIViewController {
    
    
    // MARK: - Properties
    
    private lazy var viewModel = PokemonDetailViewModel(delegate: self)
    
    private lazy var router: PokemonDetailRouter? = {
        guard let navigationController = navigationController else { return nil }
        return PokemonDetailRouter(with: navigationController)
    }()
    
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        setupConstraints()
    }
    
}


// MARK: - Setup Methods

extension PokemonDetailViewController {
    
    private func setupInterface() {}
    
    private func setupConstraints() {}
    
}


// MARK: - Navigation
    
extension PokemonDetailViewController {
    
    func prepareForNavigation(with navigationData: PokemonDetailNavigationData) {
        viewModel.prepareForNavigation(with: navigationData)
    }
 
}


// MARK: - Private methods
    
extension PokemonDetailViewController {}


// MARK: - Public methods
    
extension PokemonDetailViewController {}


// MARK: - Actions
    
extension PokemonDetailViewController {}


// MARK: - PokemonDetailDelegate

extension PokemonDetailViewController: PokemonDetailDelegate {}
