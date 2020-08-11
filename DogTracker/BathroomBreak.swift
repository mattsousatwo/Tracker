//
//  BathroomBreak.swift
//  DoggoTracker
//
//  Created by Matthew Sousa on 8/10/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import CoreData

class BathroomBreak: CoreDataHandler, DataHandler {
    var bathroomEntries: [BathroomEntry]?

    override init() {
        super.init()
        guard let foundContext = context else { return }
        entity = NSEntityDescription.entity(forEntityName: EntityNames.bathroomBreak.rawValue, in: foundContext)!
        print("BathroomBreak")
    }
    
    // Save Bathroom Entry Context
    func save() {
        guard let context = context else { return }
        do {
            try context.save()
        } catch {
            
        }
        print("Save")
    }
    
    // Create entry
    func create() {
        guard let context = context else { return }
        let entry = BathroomEntry(context: context)
        
        entry.uid = genID()
        entry.treat = false
        entry.time = Date()
        entry.notes = ""
        entry.type = 1
        entry.correctSpot = false
        save()
    }
    
    // Create entry
    func createEntry() {
        guard let context = context else { return }
        let entry = BathroomEntry(context: context)
        print("Create Entry")
        entry.uid = "NOTUNIQUE"
        entry.treat = false
        entry.time = Date()
        entry.notes = ""
        entry.type = 1
        entry.correctSpot = false
        saveSelectedContext()
        
    }
    
    // Fetch All Bathroom Entries
    func fetch() {
        guard let context = context else { return }
        let request: NSFetchRequest<BathroomEntry> = BathroomEntry.fetchRequest()
        do {
            bathroomEntries = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch bathroomBreak, error: \(error)")
        }
    }
    
    // Can change to - fetchSpecificEntry(id: String) -> BathroomEntry?
    func fetchCreatedEntry() -> BathroomEntry? {
        guard let context = context else { return nil }
        var entry: BathroomEntry?
        let request: NSFetchRequest<BathroomEntry> = BathroomEntry.fetchRequest()
        request.predicate = NSPredicate(format: "uid = %@", "NOTUNIQUE")
        do  {
            let array = try context.fetch(request)
            if array.count != 0 {
                entry = array.first!
            }
        } catch {
            
        }
        if entry != nil {
            print("fetch return != nil ")
            return entry
        } else {
            print("fetch = nil ")
            return nil
        }
    }
    
    func update() {
        
    }
    
    // Delete All BathroomBreak Entries
    func delete() {
        guard let context = context else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityNames.bathroomBreak.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
        } catch {
        }
    }
      
}

enum BathroomType: Int16 {
    case pee = 1, poop, vomit
}
