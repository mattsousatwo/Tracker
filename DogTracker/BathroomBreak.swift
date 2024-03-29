//
//  BathroomBreak.swift
//  DoggoTracker
//
//  Created by Matthew Sousa on 8/10/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import CoreData

class BathroomBreak: CoreDataHandler, ObservableObject {
    @Published var bathroomEntries: [BathroomEntry]?
    var selectedUID: String?
    
    override init() {
        super.init()
        guard let foundContext = context else { return }
        entity = NSEntityDescription.entity(forEntityName: EntityNames.bathroomBreak.rawValue, in: foundContext)!
        print("BathroomBreak()")
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
    func createNewEntry(dogUUID: String? = nil,
                        uid: String? = nil,
                        correctSpot: Bool? = nil,
                        notes: String? = nil,
                        time: Date? = nil,
                        treat: Bool? = nil,
                        type: EntryType? = nil ) -> BathroomEntry? {
        guard let context = context else { return nil }
        let entry = BathroomEntry(context: context)
        
        if let dogUUID = dogUUID {
            entry.dogUUID = dogUUID
        } else {
            let ID = genID()
            entry.dogUUID = ID
        }

        
        
        if let uid = uid {
            entry.uid = uid
        } else {
            let ID = genID()
            selectedUID = ID
            entry.uid = ID
        }

        entry.treat = false
        
        if let date = time {
            /// Format date into time and day
            let format = DateFormatter()
//            let day = format.dateFormat(date)
            let time = format.twelveHourFormat(date)
//            entry.date = day
            entry.time = time
            format.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
            entry.date = format.string(from: date)
        }
        
        entry.notes = ""
        
        
        if let entryType = type {
            entry.type = entryType.asInt
        } else {
            entry.type = 0
        }
        
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
    func update(UID: String,
                correctSpot: Bool? = nil,
                notes: String? = nil,
                date: String? = nil,
                time: String? = nil,
                treat: Bool? = nil,
                type: Int? = nil ) {
        
        print("Update -- \(UID)")
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
                date: Date? = nil,
                dogUUID: String? = nil,
                treat: Bool? = nil,
                type: Int16? = nil) {
        
        if let correctSpot = correctSpot {
            entry.correctSpot = correctSpot
        }
        if let notes = notes {
            entry.notes = notes
        }
        if let date = date {
            /// Format date into time and day
            let format = DateFormatter()
//            let day = format.dateFormat(date)
//            format.timeStyle = .short
//            let time = format.twelveHourFormat(date)
            
//            let time = format.string(from: date)
            format.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
            entry.date = format.string(from: date)
//            entry.time = time
            
        }
        if let dogUUID = dogUUID {
            entry.dogUUID = dogUUID
        }
        
        if let treat = treat {
            entry.treat = treat
        }
        if let type = type {
            entry.type = type
        }
        
        save()
    }
    
    /// Get an array of all bathroom entries associated with dogID and Entry Type
    func fetchAllEntries(for dogID: String, ofType type: EntryType) -> [BathroomEntry]? {
        guard let context = context else { return nil }
        var entries: [BathroomEntry]?
        let request: NSFetchRequest<BathroomEntry> = BathroomEntry.fetchRequest()
        
        if type != .food || type != .water {
            request.predicate = NSPredicate(format: "dogUUID == %@ AND type == %i", dogID, type.asInt)
            do {
                entries = try context.fetch(request)
            } catch  {
                print(error)
            }
            return entries
        }
        
        return nil

    }
    
    /// Get an array of all bathroom entries associated with dogID
    func fetchAllEntries(for dogID: String) -> [BathroomEntry]? {
        guard let context = context else { return nil }
        var entries: [BathroomEntry]?
        let request: NSFetchRequest<BathroomEntry> = BathroomEntry.fetchRequest()
        request.predicate = NSPredicate(format: "dogUUID == %@", dogID)
        do {
            entries = try context.fetch(request)
        } catch  {
            print(error)
        }
        return entries
    }

    
    func getEntriesForWeek(_ dates: [String], for dog: Dog, type: EntryType) -> [BathroomEntry]? {
        let formatter = DateFormatter()

        if type == .pee ||
            type == .poop ||
            type == .vomit {
            
            if let entriesForDog = fetchAllEntries(for: dog.uuid, ofType: type) {
                var entries: [BathroomEntry] = []
                for entry in entriesForDog {
                    for date in dates {
                        
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
    
    
    func convertEntriesToGraphElements(_ bathroomEntries: [BathroomEntry]) -> [GraphElement] {
        let calendar = Calendar.current
        let formatter = DateFormatter()

        var elements: [GraphElement] = []
        
        for day in Day.allCases {
            var entries: [BathroomEntry] = []
            
            for entry in bathroomEntries {
                if let stringDate = entry.date {
                    if let date = formatter.convertStringToDate(stringDate) {
                        let dayComponent = calendar.component(.weekday, from: date)
                        if dayComponent == day.component() {
                            entries.append(entry)
                        }
                    }          
                }
            }
            
            let element = GraphElement(day: day, bathroomEntries: entries)
            elements.append(element)
            print("\nEntries for \(element.day.asString()), \(element.bathroomEntries)\n")
        }
        
        return elements
    }
    
    
    
}

class GraphElement: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: GraphElement, rhs: GraphElement) -> Bool {
        return lhs.day == rhs.day &&
            lhs.bathroomEntries == rhs.bathroomEntries &&
            lhs.foodEntries == rhs.foodEntries &&
            lhs.id == rhs.id
    }
    
    let day: Day
    var bathroomEntries: [BathroomEntry]
    var foodEntries: [FoodEntry]
    private var id = UUID().uuidString
    
    init(day: Day, bathroomEntries: [BathroomEntry]? = nil, foodEntries: [FoodEntry]? = nil) {
        self.day = day
        if let bathroomEntries = bathroomEntries {
            self.bathroomEntries = bathroomEntries
        } else {
            self.bathroomEntries = []
        }
        if let foodEntries = foodEntries {
            self.foodEntries = foodEntries
        } else {
            self.foodEntries = []
        }
    }
    
    func append(bathroomEntry: BathroomEntry) {
        bathroomEntries.append(bathroomEntry)
    }
    
    func append(foodEntry: FoodEntry) {
        foodEntries.append(foodEntry)
    }

}

enum UpdateType: String {
    case name = "Name",
    email = "Email", 
    password = "Password"
}

enum Day: CaseIterable {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    func component() -> Int {
        switch self {
        case .sunday:
            return 1
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        }
    }
    
    func asString() -> String {
        switch self {
        case .sunday:
            return "Sunday"
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        }
    }

    func asAbreviatedString() -> String {
        switch self {
        case .sunday:
            return "S"
        case .monday:
            return "M"
        case .tuesday:
            return "T"
        case .wednesday:
            return "W"
        case .thursday:
            return "T"
        case .friday:
            return "F"
        case .saturday:
            return "S"
        }
    }
    
}
