//
//  Array+Extensions.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 30/07/24.
//

import Foundation

extension Array {
    
    func safeFind(at index: Int?) -> Element? {
        guard let index = index else {
            return nil
        }
        
        return index >= 0 && index < count ? self[index] : nil
    }
    
}
