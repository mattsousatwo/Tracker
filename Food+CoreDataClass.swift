//
//  Food+CoreDataClass.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/21/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Food)
public class Food: NSManagedObject {

    
    let foods = Foods()
    
    /// Update properties for food 
    func update(name: String? = nil,
                flavor: String? = nil,
                defaultAmount: FoodMeasurement? = nil,
                favorite: FavoriteKey? = nil,
                uuid: String? = nil) {
        
        if let name = name {
            self.name = name
        }
        if let flavor = flavor {
            self.flavor = flavor
        }
        if let defaultAmount = defaultAmount {
            
            guard let amount = foods.encodeFoodMeasurement(measurement: defaultAmount) else { return }
            self.defaultAmount = amount
        }

        if let favorite = favorite {
            self.isFavorite = favorite.rawValue
            if favorite.rawValue == FavoriteKey.isFavorite.rawValue {
                foods.setFavoriteFood(as: self)
            }
        }
        if let uuid = uuid {
            self.uuid = uuid
        }
        
        foods.saveSelectedContext()
    }
    
    
    // Decode default food amount
    func decodeDefaultAmount() -> FoodMeasurement {
        
        if let defaultAmount = self.defaultAmount {
            if let amount = foods.decodeToFoodMeasurement(string: defaultAmount) {
                return amount
            }
        }
        
        return FoodMeasurement(amount: 0, measurement: .teaSpoon)
    }
    
    
    // Transform isFavorite into Bool
    func favorite() -> Bool {
        switch self.isFavorite {
        case FavoriteKey.isFavorite.rawValue:
            return true
        default:
            return false
        }
    }
    
}
