//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 31/07/24.
//

import Foundation
import UIKit

struct PokemonDetail {
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonType]
}

enum PokemonType: String, Codable {
    case normal
    case fire
    case water
    case electric
    case grass
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dragon
    case dark
    case steel
    case fairy
    
    func getTitle() -> String {
            return self.rawValue.capitalizingFirstLetter()
        }
    
    func getColor() -> UIColor {
           switch self {
           case .normal:
               return UIColor(hex: "#A8A77A")
           case .fire:
               return UIColor(hex: "#EE8130")
           case .water:
               return UIColor(hex: "#6390F0")
           case .electric:
               return UIColor(hex: "#F7D02C")
           case .grass:
               return UIColor(hex: "#7AC74C")
           case .ice:
               return UIColor(hex: "#96D9D6")
           case .fighting:
               return UIColor(hex: "#C22E28")
           case .poison:
               return UIColor(hex: "#A33EA1")
           case .ground:
               return UIColor(hex: "#E2BF65")
           case .flying:
               return UIColor(hex: "#A98FF3")
           case .psychic:
               return UIColor(hex: "#F95587")
           case .bug:
               return UIColor(hex: "#A6B91A")
           case .rock:
               return UIColor(hex: "#B6A136")
           case .ghost:
               return UIColor(hex: "#735797")
           case .dragon:
               return UIColor(hex: "#6F35FC")
           case .dark:
               return UIColor(hex: "#705746")
           case .steel:
               return UIColor(hex: "#B7B7CE")
           case .fairy:
               return UIColor(hex: "#D685AD")
           }
       }
    
}
