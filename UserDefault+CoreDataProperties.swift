//
//  UserDefault+CoreDataProperties.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/27/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension UserDefault {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDefault> {
        return NSFetchRequest<UserDefault>(entityName: "UserDefault")
    }

    @NSManaged public var tag: String?
    @NSManaged public var uuid: String?
    @NSManaged public var value: Int16

}

extension UserDefault : Identifiable {

}
