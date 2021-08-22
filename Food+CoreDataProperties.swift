//
//  Food+CoreDataProperties.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/21/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var name: String?
    @NSManaged public var flavor: String?
    @NSManaged public var defaultAmount: String?
    @NSManaged public var uuid: String?
    
    @NSManaged public var isFavorite: Int16

}

extension Food : Identifiable {

}
