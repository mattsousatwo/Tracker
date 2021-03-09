//
//  Breed+CoreDataProperties.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/9/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension Breed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Breed> {
        return NSFetchRequest<Breed>(entityName: "Breed")
    }

    @NSManaged public var name: String?
    @NSManaged public var uuid: String?

}

extension Breed : Identifiable {

}
