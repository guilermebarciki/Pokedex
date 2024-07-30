//  
//  PokemonScannerViewController.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 30/07/24.
//

import UIKit

final class PokemonScannerViewController: UIViewController {
    
    
    // MARK: - Properties
    
    private lazy var viewModel = PokemonScannerViewModel(delegate: self)
    
    private lazy var router: PokemonScannerRouter? = {
        guard let navigationController = navigationController else { return nil }
        return PokemonScannerRouter(with: navigationController)
    }()
    
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        setupInterface()
        setupConstraints()
    }
    
}


// MARK: - Setup Methods

extension PokemonScannerViewController {
    
    private func setupInterface() {}
    
    private func setupConstraints() {}
    
}


// MARK: - Navigation
    
extension PokemonScannerViewController {
    
    func prepareForNavigation(with navigationData: PokemonScannerNavigationData) {
        viewModel.prepareForNavigation(with: navigationData)
    }
 
}


// MARK: - Private methods
    
extension PokemonScannerViewController {}


// MARK: - Public methods
    
extension PokemonScannerViewController {}


// MARK: - Actions
    
extension PokemonScannerViewController {}


// MARK: - PokemonScannerDelegate

extension PokemonScannerViewController: PokemonScannerDelegate {}
