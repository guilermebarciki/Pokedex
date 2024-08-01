//
//  PokemonDataPersistenceProtocol.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 31/07/24.
//

import Foundation

protocol PokemonDataPersistence {
    func savePokemonName(_ name: String)
    func isPokemonNameSaved(_ name: String) -> Bool
}
