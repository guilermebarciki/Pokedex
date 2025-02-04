//
//  UserDefaultsPokemonDataPersistence.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 01/08/24.
//

import Foundation

class UserDefaultsPokemonDataPersistence: PokemonDataPersistence {
    
    private let key = "pokemonNames"
    private let defaults = UserDefaults.standard
    
    func savePokemonName(_ name: String) {
        var names = defaults.stringArray(forKey: key) ?? [String]()
        names.append(name.lowercased())
        defaults.set(names, forKey: key)
    }
    
    func isPokemonNameSaved(_ name: String) -> Bool {
            let names = defaults.stringArray(forKey: key) ?? [String]()
        return names.contains(name.lowercased())
        }
    
}
