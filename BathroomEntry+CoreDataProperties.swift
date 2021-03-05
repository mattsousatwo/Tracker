//
//  BathroomEntry+CoreDataProperties.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/5/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension BathroomEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BathroomEntry> {
        return NSFetchRequest<BathroomEntry>(entityName: "BathroomEntry")
    }

    @NSManaged public var correctSpot: Bool
    @NSManaged public var notes: String?
    @NSManaged public var photo: Data?
    @NSManaged public var time: String?
    @NSManaged public var treat: Bool
    @NSManaged public var type: Int16
    @NSManaged public var uid: String?
    @NSManaged public var date: String?

}

extension BathroomEntry : Identifiable {

}
