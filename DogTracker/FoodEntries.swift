//
//  FoodEntries.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/27/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import CoreData

class FoodEntries: CoreDataHandler, ObservableObject {
    
    @Published var entries = [FoodEntry]()
    
    
    // Model after Dogs
    func createNewEntry(uuid: String? = nil,
                        foodID: String,
                        amount: Int16,
                        date: Date? = nil,
                        notes: String? = nil,
                        dogID: String,
                        type: EntryType = .food) {
        
        guard let context = context else { return }
        let entry = FoodEntry(context: context)
        
        // UUID
        if let uuid = uuid {
            entry.uuid = uuid
        } else {
            entry.uuid = genID()
        }
        
        // FoodID
        entry.foodID = foodID
        
        // Amount
        entry.amount = amount
        
        // Date
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        if let date = date {
            entry.date = formatter.string(from: date)
        } else {
            entry.date = formatter.string(from: Date() )
        }
        
        // Notes
        if let notes = notes {
            entry.notes = notes
        } else {
            entry.notes = ""
        }
        
        // DogID
        entry.dogID = dogID
        
        // Type
        if type != .pee ||
            type != .poop ||
            type != .vomit {
            entry.type = type.asInt
        }
        
        entries.append(entry)
        saveSelectedContext()
        
    }
    
    // create new
    
    // fetch all
    
    func fetchAll() {
        guard let context = context else { return }
        let request: NSFetchRequest<FoodEntry> = FoodEntry.fetchRequest()
        do {
            entries = try context.fetch(request)
        } catch {
            print("Could not fetch food entries, \(error)")
        }
    }
    
    /// Get all Entries for a selected food
    func fetchEntries(for food: Food) -> [FoodEntry]? {
        guard let context = context else { return nil }
        var entriesForFood: [FoodEntry]?
        let request: NSFetchRequest<FoodEntry> = FoodEntry.fetchRequest()
        guard let foodID = food.uuid else { return nil }
        request.predicate = NSPredicate(format: "foodID == %@", foodID)
        do {
            entriesForFood = try context.fetch(request)
        } catch {
            print("Could not fetch food entries, \(error)")
        }
        return entriesForFood
    }
    
    /// Get all entries for a selected food during a selected period
    
    
    
    
    func fetchAll(entries: EntryType, for dog: Dog) -> [FoodEntry]? {
        guard let context = context else { return nil }
        var entriesForDog: [FoodEntry]?
        let request: NSFetchRequest<FoodEntry> = FoodEntry.fetchRequest()
        request.predicate = NSPredicate(format: "dogID == %@ AND type == %i", dog.uuid, entries.asInt)
        do {
            entriesForDog = try context.fetch(request)
        } catch {
            print("Could not fetch food entries, \(error)")
        }
        return entriesForDog
    }
    
    
    func getEntries(in week: [String], for dog: Dog, ofType type: EntryType) -> [FoodEntry]? {
        let formatter = DateFormatter()
        
        
        if type == .food || type == .water {
            
            if let entriesForDog = fetchAll(entries: type, for: dog) {
                var entries: [FoodEntry] = []
                for entry in entriesForDog {
                    for date in week {
                        if let entryDate = entry.date {
                            if let comparison = formatter.compareDates(entryDate, date) {
                                if comparison == true {
                                    entries.append(entry)
                                }
                            }
                        }
                    }
                }
                return entries
                
            }
            
            
        }
        
        
        return nil
    }
    
    
    func convertFoodEntriesToGraphElements(_ foodEntries: [FoodEntry]) -> [GraphElement] {
        let calendar = Calendar.current
        let formatter = DateFormatter()

        var elements: [GraphElement] = []
        
        for day in Day.allCases {
            var entries: [FoodEntry] = []
            
            for entry in foodEntries {
                if let stringDate = entry.date {
                    if let date = formatter.convertStringToDate(stringDate) {
                        let dayComponent = calendar.component(.weekday, from: date)
                        if dayComponent == day.component() {
                            entries.append(entry)
                        }
                    }
                }
            }
            
            let element = GraphElement(day: day, foodEntries: entries)
            elements.append(element)
            print("\nEntries for \(element.day.asString()), \(element.foodEntries)\n")
        }
        
        return elements
    }
    
}

extension FoodEntries {
    
    /// Return all entries of a certain food type in a specified week
    func getAllEntries(for food: Food, in week: [String]) -> [FoodEntry] {
        var entries: [FoodEntry] = []
        guard let inputFoodEntries = fetchEntries(for: food) else { return entries }
        for entry in inputFoodEntries {
            for day in week {
                guard let entryDate = entry.date else { return entries }
                guard let datesAreEqual = formatter.compareDates(entryDate, day) else { return entries }
                if datesAreEqual == true {
                    entries.append(entry)
                }
            }
        }
        return entries
    }
}
