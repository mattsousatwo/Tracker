//
//  Dog+CoreDataClass.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Dog)
public class Dog: NSManagedObject {

    let dogs = Dogs()
    
    /// Update properties for self
    func update(name: String? = nil,
                weight: Double? = nil,
                breed: String? = nil,
                birthdate: String? = nil,
                isFavorite: DogFavoriteKey? = nil) {
        
        if let name = name {
            self.name = name
        }
        if let weight = weight {
            self.weight = weight
        }
        if let breed = breed {
            self.breed = breed
        }
        if let birthdate = birthdate {
            self.birthdate = birthdate
        }
        if let isFavorite = isFavorite {
            self.isFavorite = isFavorite.rawValue
        }
        if self.hasChanges == true {
            dogs.saveSelectedContext()
        }
    }
    
    
    
    
}
