//
//  Double+Extensions.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 31/07/24.
//

import Foundation

extension Double {
    func formattedHeight() -> String {
        return self == floor(self) ? "\(Int(self))m" : "\(self)m"
    }
    
    func formattedWeight() -> String {
        return self == floor(self) ? "\(Int(self))kg" : "\(self)kg"
    }
}
