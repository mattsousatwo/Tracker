//
//  CoreDataHanlder.swift
//  DoggoTracker
//
//  Created by Matthew Sousa on 8/10/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHandler: Conversion {
    var context: NSManagedObjectContext?
    var entity: NSEntityDescription?
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    override init() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        context = appDel.persistentContainer.viewContext
//        guard let foundContext = context else { return }
//        entity = NSEntityDescription.entity(forEntityName: EntityNames.bathroomBreak.rawValue, in: foundContext)!
        print("CoreDataHandler")
    }
    
    /// Generate ID - With numbers and letters
    func genID(idLength: Int = 5) -> String {
        let letters = ["A", "B", "C", "D", "E", "F",
                       "G", "H", "I", "J", "K", "L",
                       "M", "N", "O", "P", "Q", "R",
                       "S", "T", "U", "V", "W", "X",
                       "Y", "Z"]
        // tempID
        var id: String = ""
        // for 1 - idLength choose a random number
        for _ in 1...idLength {
            let x = Int.random(in: 0...10000)
            // if x is more than 5000 choose a letter
            if x >= 5000 {
                let chosenLetter = letters[Int.random(in: 0..<letters.count)]
                id += chosenLetter
            } else { // choose a number between 0 - 9
                let chosenInt = "\(Int.random(in: 0..<9))"
                id += chosenInt
            }
        }
        return id
    }
    
    /// Save Entry Context
    func saveSelectedContext() {
        guard let context = context else { return }
        do {
            try context.save()
        } catch {
            
        }
        print("Save")
    }
    
    /// Delete all for type
    func deleteAll(_ name: EntityNames) {
        guard let context = context else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
    }
    
    /// Delete specific element using id
    func deleteSpecificElement(_ name: EntityNames, id: String) {
        guard let context = context else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name.rawValue)
        switch name {
        case .bathroomBreak:
            request.predicate = NSPredicate(format: "uid == %@", id)
        // Dog, Breed
        default:
            request.predicate = NSPredicate(format: "uuid == %@", id)
        }
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
    }
    

}

enum EntityNames: String {
    case bathroomBreak = "BathroomEntry"
    case dog = "Dog"
    case breed = "Breed"
    case food = "Food"
    case userDefaults = "UserDefault"
    case foodEntry = "FoodEntry"
}

