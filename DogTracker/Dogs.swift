//
//  Dogs.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import CoreData

class Dogs: CoreDataHandler {
    
    var allDogs: [Dog]?
    
    override init() {
        super.init()
        guard let foundContext = context else { return }
        entity = NSEntityDescription.entity(forEntityName: EntityNames.dog.rawValue, in: foundContext)!
        print("Dogs")
    }

    /// Create a new dog entity
    func createNewDog(name: String? = nil,
                      breed: String? = nil,
                      uuid: String? = nil,
                      weight: Double? = nil,
                      birthdate: String? = nil) -> Dog?  {
        guard let context = context else { return nil }
        let newDog = Dog(context: context)
        
        // ID
        if let uuid = uuid {
            newDog.uuid = uuid
        } else {
            newDog.uuid = genID()
        }
        // Weight
        if let weight = weight {
            newDog.weight = weight
        }
        // Birthday
        if let birthdate = birthdate {
            newDog.birthdate = birthdate
        }
        // Breed
        if let breed = breed {
            newDog.breed = breed
        }
        // Name
        if let name = name {
            newDog.name = name
        } else {
            newDog.name = "NO NAME SET"
        }
        
        saveSelectedContext()
        return newDog
        
    }
    
    /// Fetch All Bathroom Entries
    func fetchAll() {
        guard let context = context else { return }
        let request: NSFetchRequest<Dog> = Dog.fetchRequest()
        do {
            allDogs = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch Dog, error: \(error)")
        }
    }

    
    
}
