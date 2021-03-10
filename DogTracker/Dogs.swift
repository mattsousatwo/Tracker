//
//  Dogs.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import CoreData

class Dogs: CoreDataHandler, ObservableObject {
    
    @Published var allDogs: [Dog]?
    @Published var favoriteDog: Dog?
    
    
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
                      birthdate: String? = nil,
                      isFavorite: Bool? = nil) -> Dog?  {
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
        // Favorite
        if let isFavorite = isFavorite {
            switch isFavorite {
            case true :
                newDog.isFavorite = DogFavoriteKey.isFavorite.rawValue
            case false:
                newDog.isFavorite = DogFavoriteKey.notFavorite.rawValue
            }
        }
        
        saveSelectedContext()
        return newDog
        
    }
    
    /// Fetch All Dogs
    func fetchAll() {
        guard let context = context else { return }
        let request: NSFetchRequest<Dog> = Dog.fetchRequest()
        do {
            allDogs = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch Dog, error: \(error)")
        }
    }
    
    /// Fetch for dog where isFavorite == true
    func fetchFavoriteDog() -> Dog? { 
        guard let context = context else { return nil }
        let request: NSFetchRequest<Dog> = Dog.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite = %i", 1)
        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                if let favoriteDog = result.first {
                    self.favoriteDog = favoriteDog
                    return favoriteDog
                }
            }
        } catch {
            print(error)
        }
        return nil
    }

    /// Returns favorite dog, if none was set the first dog fetched will be set to favorite
    func getFavoriteDog() -> Dog? {
        fetchAll()
        guard let allDogs = allDogs else { return nil }
        if allDogs.count == 0 {
            return nil
        } else {
            if let favorite = allDogs.first(where: { $0.isFavorite == 1 }) {
                return favorite
            } else {
                if let newFavorite = allDogs.first {
                    newFavorite.update(isFavorite: .isFavorite)
                    return newFavorite
                }
            }
        }
        return nil
    }
    
    
    
    /// Clear favorite dog and set a new dog to favorite
    func updateFavorite(dog: Dog, in dogsArray: [Dog]) {
        
        for dog in dogsArray {
            if dog.isFavorite == 1 {
                dog.update(isFavorite: .notFavorite)
                print("\(dog.name ?? "NONAME") isFavorite = false")
            }
        }
        
        dog.update(isFavorite: .isFavorite)
        print("\(dog.name ?? "NONAME") isFavorite = true")
        
    }
    
    
    
}

enum DogFavoriteKey: Int16 {
    case isFavorite = 1
    case notFavorite = 0
}
