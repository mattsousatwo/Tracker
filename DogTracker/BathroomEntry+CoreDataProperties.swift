//
//  BathroomEntry+CoreDataProperties.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/10/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension BathroomEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BathroomEntry> {
        return NSFetchRequest<BathroomEntry>(entityName: "BathroomEntry")
    }

    @NSManaged public var uid: String
    @NSManaged public var time: Date?
    @NSManaged public var correctSpot: Bool
    @NSManaged public var notes: String?
    @NSManaged public var type: Int16
    @NSManaged public var treat: Int16
    @NSManaged public var photo: Data?

}
