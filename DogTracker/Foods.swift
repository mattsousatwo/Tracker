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
                       defaultAmount: FoodMeasurement? = nil,
                       favorite: FavoriteKey?) -> Food? {
        guard let context = context else { return nil }
        let newFood = Food(context: context)
        
        newFood.uuid = UUID().uuidString
        newFood.name = name
        newFood.flavor = flavor
        
        if let defaultAmount = defaultAmount {
            if let measurement = encodeFoodMeasurement(measurement: defaultAmount) {
                newFood.defaultAmount = measurement
            }
        }
        
        switch favorite {
        case .isFavorite:
            setFavoriteFood(as: newFood)
        default:
            newFood.isFavorite = FavoriteKey.notFavorite.rawValue
        }
        
        allFoods.append(newFood)
        saveSelectedContext()
        
        return newFood
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
        refreshAllFoods()
        for food in allFoods {
            if food.isFavorite == FavoriteKey.isFavorite.rawValue {
                return food
            }
        }
        return nil 
    }
    
    func fetchFavoriteFood() -> Food? {
        guard let context = context else { return nil }
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == 1")
        do {
            let fetchedFood = try context.fetch(request)
            guard let favoriteFood = fetchedFood.first else { return nil }
            return favoriteFood
        } catch {
            print(error)
        }
        return nil
    }
    
    /// Replace Favorite Food with selected food
    func setFavoriteFood(as food: Food) {
        if let favorite = fetchFavoriteFood() {
            favorite.update(favorite: .notFavorite)
            food.update(favorite: .isFavorite)
        } else {
            food.update(favorite: .isFavorite)
        }
    }

    // Delete a specific food element 
    func deleteFood(id: String) {
        deleteSpecificElement(.food, id: id)
    }
    
}


/// Deleting Rows
extension Foods {
    
    
    /// Delete Row
    func deleteFood(at offsets: IndexSet, in foodList: [Food], onDelete: (), onLastDelete: () ) {
        guard let index = offsets.first else { return }
        let selectedFood = foodList[index]
        
        if selectedFood.favorite() == true {
            replaceFavoriteSelection(at: index,
                                     in: foodList,
                                     onLastDelete: onLastDelete)
        }
        
        if let foodID = selectedFood.uuid {
            deleteSpecificElement(.food,
                                  id: foodID)
            onDelete
            
        }
    }
    
    /// Replace favorite food with the one closest to it if deleted
    func replaceFavoriteSelection(at index: Int, in foodList: [Food], onLastDelete: () ) {
        switch index {
        case 0: // First
            if foodList.count == 1 {
                onLastDelete
            } else if foodList.count >= 2 {
                setFavoriteFood(as: foodList[index + 1])
            }
        case foodList.count - 1: // Last
            setFavoriteFood(as: foodList[index - 1])
        default: // Inbetween
            if foodList.count == index - 1 {
                setFavoriteFood(as: foodList[index - 1])
            } else if foodList.count != index + 1 {
                setFavoriteFood(as: foodList[index + 1])
            }
        }
    }
    
    /// Assign left over food as favorite if not favorited
    func assignOnlyFoodAsFavorite(in foodList: [Food]) {
        if foodList.count == 1 {
            guard let onlyFood = foodList.first else { return }
            if onlyFood.favorite() == false {
                setFavoriteFood(as: onlyFood)
            }
        }
    }

}
