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
    
    func fetchAll(entries: EntryType, for dog: Dog) -> [FoodEntry]? {
        guard let context = context else { return nil }
        var entriesForDog: [FoodEntry]?
        let request: NSFetchRequest<FoodEntry> = FoodEntry.fetchRequest()
        request.predicate = NSPredicate(format: "dogID == %@", dog.uuid)
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

