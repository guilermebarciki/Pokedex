//
//  String+Extensions.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

extension String {
    
    func extractPokemonNumber() -> Int? {
        let components = self.split(separator: "/")
        if let lastComponent = components.last, lastComponent.isEmpty, components.count > 1 {
            return Int(components[components.count - 2])
        } else if let lastComponent = components.last {
            return Int(lastComponent)
        }
        return nil
    }
    
}
