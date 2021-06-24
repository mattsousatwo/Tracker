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
    let encoder = JSONEncoder()
    let decoder = JSONDecoder() 
    
    /// Update properties for self
    func update(name: String? = nil,
                weight: Double? = nil,
                breed: [String]? = nil,
                birthdate: Date? = nil,
                isFavorite: DogFavoriteKey? = nil) {
        
        if let name = name {
            self.name = name
        }
        if let weight = weight {
            self.weight = weight
        }
        if let breed = breed {
            self.encode(breeds: breed)
        }
        if let birthdate = birthdate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let convertedDate = formatter.string(from: birthdate)
            print("\n - saved birthday: \(convertedDate)\n")
            
            
            self.birthdate = convertedDate
            
        }
        if let isFavorite = isFavorite {
            self.isFavorite = isFavorite.rawValue
        }
        if self.hasChanges == true {
            dogs.saveSelectedContext()
        }
    }
    
    func encode(breeds: [String]) {
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(breeds) else { return }
        self.breed = String(data: data, encoding: .utf8)
        if self.hasChanges == true {
            dogs.saveSelectedContext()
        }
    }
    
    func decodeBreeds() -> [String]? {
        guard let breeds = self.breed else { return nil }
        guard let data = breeds.data(using: .utf8) else { return nil }
        guard let selectedBreeds = try? decoder.decode([String].self, from: data) else { return nil }
        return selectedBreeds
    }

    
    
}
