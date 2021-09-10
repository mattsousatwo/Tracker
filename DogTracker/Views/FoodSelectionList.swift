//
//  FoodSelectionList.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/21/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct FoodSelectionList: View {
    
    @Binding var favoriteFood: Food?
    @Binding var isPresented: Bool
    
    @ObservedObject var foods = Foods()
    @State var foodList = [Food]()
    
    
    /// Create new food segue
    @State var createNewFoodIsPresented: Bool = false
    /// View State of create new food
    @State var foodCount: Int = 0
    
    var body: some View {

        NavBar(left: { cancelButton() },
               center: { Text("Food List").bold() },
               right: { addFoodButton() })
        
            List {
                if foodCount != 0 {
                    allFoodsList()
                }
                if foodCount == 0 {
                    createNewFoodButton()
                }
                
            }
            .animation(.default)
            .onChange(of: foodList) { (_) in
                foodCount = foodList.count
                updateFavoriteSelection()
            }
            .onAppear {
                if foods.allFoods.count == 0 {
                    foodList = foods.getAllFoods()
                    foodCount = foodList.count
                    
                    if foods.allFoods.count == 0 {
                        createNewFoodIsPresented = true
                    }
                }
            }
            
        }
    

}

// Views
@available(iOS 14.0, *)
extension FoodSelectionList {
    
    /// For each food in foodList produce a TextView
    func allFoodsList() -> some View {
        return
            ForEach(foodList, id: \.self) { food in
                if let foodsName = food.name {
                    Button {
                        favoriteFood = food
                        if let food = favoriteFood {
                            foods.setFavoriteFood(as: food)
                        }
                        isPresented = false
                    } label: {

                        switch food.isFavorite {
                        case FavoriteKey.isFavorite.rawValue:
                            allFoodListRow(title: foodsName, color: .blue)
                        default:
                            allFoodListRow(title: foodsName, color: .primary)
                        }
                        
                        
               
                    }.tag(food)
                    
                    
                }
            }
            .onDelete { index in
                foods.deleteFood(at: index,
                                 in: foodList,
                                 onDelete: delete(at: index),
                                 onLastDelete: onLastDelete())
            }
//            .onDelete(perform: deleteFoodRow)
    }
    
    // Row within allFoodsList
    func allFoodListRow(title: String, color: Color) -> some View {
        return
            Text(title)
                .foregroundColor(color)
                .padding()
    }
    
    /// Display View to add new food to list
    func createNewFoodButton() -> some View {
        return
            Button {
                createNewFoodIsPresented.toggle()
        } label: {
            Text("Create new food")
                .padding()
        }
            .sheet(isPresented: $createNewFoodIsPresented) {
            // Create new food view
                NewFoodEntry(isPresented: $createNewFoodIsPresented, foodList: $foodList)
            }
    }
    
    /// Add button in nav bar
    func addFoodButton() -> some View {
        return
            Button {
                createNewFoodIsPresented.toggle()
        } label: {
            Image(systemName: "plus")
                .padding()
        }
            .sheet(isPresented: $createNewFoodIsPresented) {
            // Create new food view
                NewFoodEntry(isPresented: $createNewFoodIsPresented,
                             foodList: $foodList)
            }
    }
    
    /// Display View to add new food to list
    func cancelButton() -> some View {
        return
            Button {
                self.isPresented = false
        } label: {
            Text("Cancel")
                .foregroundColor(.red)
                .padding()
        }
    }
}

// Protocol - FoodList
@available(iOS 14.0, *)
extension FoodSelectionList: FoodList {
    
   /// if deleting a row
   func delete(at set: IndexSet) {
       guard let index = set.first else { return }
       if foodList[index] == favoriteFood {
           favoriteFood = nil
       }
       foodList.remove(at: index)
       foodCount = foodCount - 1
       updateFavoriteSelection()
   }
   
   /// if deleting last row
   func onLastDelete() {
       favoriteFood = nil
       foodCount = foodCount - 1
   }
    
    /// Comapare existing favorite food with favorite food in foodList
    func updateFavoriteSelection() {
        switch foodList.count {
        case 1:
            foods.assignOnlyFoodAsFavorite(in: foodList)
            guard let onlyfood = foodList.first else { return }
            self.favoriteFood = onlyfood
        default:
            for food in foodList {
                if food.favorite() == true {
                    if food != favoriteFood {
                        self.favoriteFood = food
                    }
                }
            }
        }
        
    }

//    /// Replace the favorite food with the one closest to it
//    func replaceFavoriteSelection(at index: Int) {
//        favoriteFood = nil
//        switch index {
//        case 0: // First
//            if foodList.count == 0 {
//                self.createNewFoodIsPresented.toggle()
//            } else if foodList.count == 1 {
//                foodCount = 0 // Trigger create new button
//            } else if foodList.count >= 2 {
//                let food = foodList[index + 1]
//                food.update(favorite: .isFavorite)
//                favoriteFood = food
//            }
//        case foodList.count - 1: // Last
//            let food = foodList[index - 1]
//            food.update(favorite: .isFavorite)
//            favoriteFood = food
//        default: // Inbetween
//            if foodList.count == index - 1 { // is equal to last element
//                let food = foodList[index - 1]
//                food.update(favorite: .isFavorite)
//                favoriteFood = food
//
//            } else if foodList.count != index + 1 { // Not equal to last element
//                let food = foodList[index + 1]
//                food.update(favorite: .isFavorite)
//                favoriteFood = food
//            }
//        }
//    }
    
}

//struct FoodSelectionList_Previews: PreviewProvider {
//
//
//    static var previews: some View {
//        FoodSelectionList(favoriteFood: $food,
//                          isPresented: .constant(true))
//    }
//}

