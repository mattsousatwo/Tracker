//
//  FoodEntry+CoreDataProperties.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/27/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension FoodEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEntry> {
        return NSFetchRequest<FoodEntry>(entityName: "FoodEntry")
    }

    @NSManaged public var uuid: String?
    @NSManaged public var foodID: String?
    @NSManaged public var measurement: String?
    @NSManaged public var date: String?
    @NSManaged public var notes: String?
    @NSManaged public var dogID: String?
    @NSManaged public var type: Int16

}

extension FoodEntry : Identifiable {

}
