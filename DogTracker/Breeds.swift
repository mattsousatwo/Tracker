//
//  Breeds.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/9/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import CoreData

class Breeds: CoreDataHandler {
    
    var allBreeds = [Breed]()
    
    override init() {
        super.init()
        guard let foundContext = context else { return }
        entity = NSEntityDescription.entity(forEntityName: EntityNames.breed.rawValue, in: foundContext)!
        print("Breeds()")
    }
    
    /// Create a new Breed
    func createNew(breed name: String) {
        guard let context = context else { return }
        let newBreed = Breed(context: context)
        
        newBreed.uuid = genID()
        newBreed.name = name
        
        saveSelectedContext()
    }
    
    /// Fetch all breeds
    func fetchAll() {
        guard let context = context else { return }
        let request: NSFetchRequest<Breed> = Breed.fetchRequest()
        do {
            allBreeds = try context.fetch(request)
        } catch {
            print(error)
        }

    }
    
}
