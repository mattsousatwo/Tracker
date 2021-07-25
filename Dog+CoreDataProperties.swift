//
//  Dog+CoreDataProperties.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension Dog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog> {
        return NSFetchRequest<Dog>(entityName: "Dog")
    }

    @NSManaged public var uuid: String
    @NSManaged public var name: String?
    @NSManaged public var weight: Double
    @NSManaged public var breed: String?
    @NSManaged public var birthdate: String?
    @NSManaged public var isFavorite: Int16
    @NSManaged public var image: Data?

}

extension Dog : Identifiable {

}
