//
//  FoodEntry+CoreDataClass.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/27/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData

@objc(FoodEntry)
public class FoodEntry: NSManagedObject {

    let foodEntries = FoodEntries()
    
    func update(foodID: String? = nil,
                measurement: FoodMeasurement? = nil,
                date: Date? = nil,
                notes: String? = nil,
                dogID: String? = nil,
                type: EntryType? = nil) {
        
        if let foodID = foodID {
            self.foodID = foodID
        }
        if let measurement = measurement {
            guard let amount = foodEntries.encodeFoodMeasurement(measurement: measurement) else { return }
            self.measurement = amount
        }
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
            let dateString = formatter.string(from: date)
            self.date = dateString
        }
        if let notes = notes {
            self.notes = notes
        }
        if let dogID = dogID {
            self.dogID = dogID
        }
        if let type = type {
            if type != .pee || type != .poop || type != .vomit {
                self.type = type.asInt
            }
        }
        foodEntries.saveSelectedContext()
    }
    
}
