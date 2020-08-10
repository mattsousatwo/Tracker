//
//  BathroomBreak.swift
//  DoggoTracker
//
//  Created by Matthew Sousa on 8/10/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import CoreData

class BathroomBreakClass: CoreDataHandler, DataHandler {
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
    }
    
    // Create entry
    func create() {
        guard let context = context else { return }
        let entry = BathroomEntry(context: context)
        
        entry.uid = genID()
//        entry.treat = false
        entry.time = Date()
        entry.notes = ""
        entry.type = 1
        entry.correctSpot = false
        
    }
    
    // Create entry
    func createEntry() {
        guard let context = context else { return }
        let entry = BathroomEntry(context: context)
        
        entry.uid = genID()
//        entry.treat = false
        entry.time = Date()
        entry.notes = ""
        entry.type = 1
        entry.correctSpot = false
        
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
    
    func update() {
        
    }
    
    func delete() {
        
    }
      
}

enum BathroomType: Int16 {
    case pee = 1, poop, vomit
}
