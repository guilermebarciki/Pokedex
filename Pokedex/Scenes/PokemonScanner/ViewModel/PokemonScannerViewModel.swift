//  
//  PokemonScannerViewModel.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 30/07/24.
//

import Foundation

protocol PokemonScannerDelegate: AnyObject {}

typealias PokemonScannerNavigationData = Any

final class PokemonScannerViewModel {
    
    
    // MARK: - Properties
    
    weak var delegate: PokemonScannerDelegate?
    
    
    // MARK: - Init
    
    init(delegate: PokemonScannerDelegate?) {
        self.delegate = delegate
    }
    
}


// MARK: - Navigation

extension PokemonScannerViewModel {
    
    func prepareForNavigation(with navigationData: PokemonScannerNavigationData) {}
    
}
    

// MARK: - Fetch Methods

extension PokemonScannerViewModel {}
