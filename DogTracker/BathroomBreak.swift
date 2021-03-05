//
//  BathroomBreak.swift
//  DoggoTracker
//
//  Created by Matthew Sousa on 8/10/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import CoreData

class BathroomBreak: CoreDataHandler {
    var bathroomEntries: [BathroomEntry]?
    var selectedUID: String?
    
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
    func createNewEntry(uid: String? = nil,
                        correctSpot: Bool? = nil,
                        notes: String? = nil,
                        time: Date? = nil,
                        treat: Bool? = nil,
                        type: Int? = nil ) -> BathroomEntry? {
        guard let context = context else { return nil }
        let entry = BathroomEntry(context: context)
        
        if let uid = uid {
            entry.uid = uid
        } else {
            let ID = genID()
            selectedUID = ID
            entry.uid = ID
        }
        
        
        entry.treat = false
        
        // MARK: Format Time -
        entry.time = "Date"
        
        entry.notes = ""
        
        entry.type = 0
        
        entry.correctSpot = false
        
        save()
        return entry
    }
    
    /// Fetch All Bathroom Entries
    func fetchAll() {
        guard let context = context else { return }
        let request: NSFetchRequest<BathroomEntry> = BathroomEntry.fetchRequest()
        do {
            bathroomEntries = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch bathroomBreak, error: \(error)")
        }
    }
    
    // Can change to - fetchSpecificEntry(id: String) -> BathroomEntry?
    func fetchBathroomEntry(uid: String) -> BathroomEntry? {
        guard let context = context else { return nil }
        var entry: BathroomEntry?
        let request: NSFetchRequest<BathroomEntry> = BathroomEntry.fetchRequest()
        request.predicate = NSPredicate(format: "uid = %@", uid)
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
            print("fetch = nil - create")
            let newEntry = createNewEntry()
            return newEntry
        }
    }
        
    // Update specific entry
    func update(entry selectedUID: String,
                correctSpot: Bool? = nil,
                notes: String? = nil,
                date: String? = nil,
                time: String? = nil,
                treat: Bool? = nil,
                type: Int? = nil ) {
        
        print("Update -- \(selectedUID)")
        // Find selected entry in bathroomEntries
        let selectedEntry = bathroomEntries?.first(where: {brEntry in
            brEntry.uid == selectedUID
        })
        // If found
        if selectedEntry?.uid == selectedUID {
            // Unwrap selected entry
            guard let entry = selectedEntry else { return }
            
            
            // update values if found
            // CorrectSpot
            if correctSpot != nil {
                guard let spot = correctSpot else { return }
                entry.correctSpot = spot
                print("correctSpot == \(spot)")
            }
            // Notes
            if notes != nil {
                guard let notes = notes else { return }
                entry.notes = notes
                print("notes == \(notes)")
            }
            // Time
            if time != nil {
                guard let time = time else { return }
                // MARK: Format Time -
                entry.time = "time"
                print("time == \(time)")
            }
            // Treat
            if treat != nil {
                guard let treat = treat else { return }
                entry.treat = treat
                print("treat == \(treat)")
            // Type
            if type != nil {
                guard let type = type else { return }
                entry.type = Int16(type)
                print("type == \(type)")
            }
            // Save
            save()
            }
        }
    }
    
    
    func update(entry: BathroomEntry,
                correctSpot: Bool? = nil,
                notes: String? = nil,
                date: String? = nil,
                time: String? = nil,
                treat: Bool? = nil,
                type: Int? = nil) {
        
        if let correctSpot = correctSpot {
            entry.correctSpot = correctSpot
        }
        if let notes = notes {
            entry.notes = notes
        }
        if let date = date {
            entry.date = date
        }
        if let time = time {
            // MARK: Format Time -
            entry.time = time
        }
        if let treat = treat {
            entry.treat = treat
        }
        if let type = type {
            entry.type = Int16(type)
        }
        
        save()
    }
    
    
    // Delete All BathroomBreak Entries
    func deleteAll() {
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
    case pee = 1, poop, food, water, vomit
    
    func decipher(_ type: BathroomType) -> String {
        switch type {
        case .pee:
            return "pee"
        case .poop:
            return "poop"
        case .food:
            return "food"
        case .water:
            return "water"
        case .vomit:
            return "vomit"

        }
    }
    
    
}

enum UpdateType: String {
    case name = "Name",
    email = "Email", 
    password = "Password"
}
