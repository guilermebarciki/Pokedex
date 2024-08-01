//
//  PokemonEntity+CoreDataProperties.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//
//

import Foundation
import CoreData

extension PokemonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonEntity> {
        return NSFetchRequest<PokemonEntity>(entityName: "PokemonEntity")
    }

    @NSManaged public var name: String?

}

extension PokemonEntity : Identifiable {

}
