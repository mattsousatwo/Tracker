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
                defaultAmount: String? = nil,
                favorite: FavoriteKey? = nil,
                uuid: String? = nil) {
        
        if let name = name {
            self.name = name
        }
        if let flavor = flavor {
            self.flavor = flavor
        }
        if let defaultAmount = defaultAmount {
            self.defaultAmount = defaultAmount
        }

        if let favorite = favorite {
            self.isFavorite = favorite.rawValue
        }
        if let uuid = uuid {
            self.uuid = uuid
        }
        
        foods.saveSelectedContext()
    }
}
