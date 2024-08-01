//
//  CoreDataPokemonDataPersistence.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 01/08/24.
//

import Foundation
import CoreData

class CoreDataPokemonDataPersistence: PokemonDataPersistence {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    func savePokemonName(_ name: String) {
        let entity = PokemonEntity(context: context)
        entity.name = name.lowercased()
        saveContext()
    }
    
    func isPokemonNameSaved(_ name: String) -> Bool {
        let fetchRequest: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name.lowercased())
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            return false
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
}
