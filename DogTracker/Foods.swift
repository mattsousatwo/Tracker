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
    func createNewFood(name: String,
                       flavor: String,
                       defaultAmount: String? = nil,
                       favorite: FavoriteKey?) {
        guard let context = context else { return }
        let newFood = Food(context: context)
        
        newFood.uuid = UUID().uuidString
        newFood.name = name
        newFood.flavor = flavor
        if let defaultAmount = defaultAmount {
            newFood.defaultAmount = defaultAmount
        }
        
        if favorite != nil {
            setFavoriteFood(as: newFood)
        } else {
            newFood.isFavorite = FavoriteKey.notFavorite.rawValue
        }
        
        
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
    
    /// Load foods
    func refreshAllFoods() {
        if allFoods.count == 0 {
            fetchAll()
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
    
    /// Fetch favorite Food
    func getFavoriteFood() -> Food? {
        let allFoods = getAllFoods()
        for food in allFoods {
            if food.isFavorite == FavoriteKey.isFavorite.rawValue {
                return food
            }
        }
        return nil 
    }
    
    /// Replace Favorite Food with selected food
    func setFavoriteFood(as food: Food) {
        refreshAllFoods()
        if allFoods.count != 0 {
            for food in allFoods {
                if food.isFavorite == FavoriteKey.isFavorite.rawValue {
                    food.update(favorite: .notFavorite)
                }
            }
        }
        
        food.update(favorite: .isFavorite)
    }

    
    
}
