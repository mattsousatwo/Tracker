//
//  Foods.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/21/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import CoreData

class Foods: CoreDataHandler, ObservableObject {
    
    @Published var allFoods = [Food]()
    
    override init() {
        super.init()
        guard let foundContext = context else { return }
        entity = NSEntityDescription.entity(forEntityName: EntityNames.food.rawValue,
                                            in: foundContext)!
        print("Foods()")
    }
    
    /// Create a new food item
    func createNew(food: String) {
        guard let context = context else { return }
        let newFood = Food(context: context)
        
        newFood.uuid = UUID().uuidString
        newFood.name = food
        
        saveSelectedContext()
    }
    
    /// Get all Foods
    func fetchAll() {
        guard let context = context else { return }
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        do {
            allFoods = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    /// Get all foods
    func getAllFoods() -> [Food] {
        if allFoods.count == 0 {
            fetchAll()
        } else {
            return allFoods
        }
        return allFoods
    }
    
}
