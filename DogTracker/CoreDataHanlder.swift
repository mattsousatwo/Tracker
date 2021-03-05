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
    
    
    override init() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        context = appDel.persistentContainer.viewContext
//        guard let foundContext = context else { return }
//        entity = NSEntityDescription.entity(forEntityName: EntityNames.bathroomBreak.rawValue, in: foundContext)!
        print("CoreDataHandler")
    }
    
    // Generate ID - With numbers and letters
    func genID() -> String {
        let letters = ["A", "B", "C", "D", "E", "F",
                       "G", "H", "I", "J", "K", "L",
                       "M", "N", "O", "P", "Q", "R",
                       "S", "T", "U", "V", "W", "X",
                       "Y", "Z"]
        // desired ID length
        let idLength = 5
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
    
    // Save Bathroom Entry Context
    func saveSelectedContext() {
        guard let context = context else { return }
        do {
            try context.save()
        } catch {
            
        }
        print("Save")
    }

}

enum EntityNames: String {
    case bathroomBreak = "BathroomEntry"
}

