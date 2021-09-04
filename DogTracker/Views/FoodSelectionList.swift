//
//  FoodSelectionList.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/21/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

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
        
        HStack {
            cancelButton()
            Spacer()
            Text("Food List").bold()
            Spacer()
            addFoodButton()
        }

 
        
        if #available(iOS 14.0, *) {
            List {
                allFoodsList()
                
                if foodCount == 0 {
                    createNewFoodButton()
                }
                
            }
            .onChange(of: foodList) { (_) in
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
    
    
    /// Comapare existing favorite food with favorite food in foodList
    func updateFavoriteSelection() {
        if let favoriteFood = favoriteFood {
            for food in foodList {
                if food.isFavorite == FavoriteKey.isFavorite.rawValue {
                    if food != favoriteFood {
                        self.favoriteFood = food
                    }
                }
            }
        }
    }
    
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
            } .onDelete(perform: deleteFoodRow)
    }
    
    /// Delete selected row 
    func deleteFoodRow(at offsets: IndexSet) {
        let selectedFood = foodList[offsets.first!]
        if let foodID = selectedFood.uuid {
            foods.deleteSpecificElement(.food,
                                        id: foodID)
            foodList.removeAll(where: { $0.uuid == foodID })
        }
        
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
                NewFoodEntry(isPresented: $createNewFoodIsPresented, foodList: $foodList)
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

//struct FoodSelectionList_Previews: PreviewProvider {
//
//
//    static var previews: some View {
//        FoodSelectionList(favoriteFood: $food,
//                          isPresented: .constant(true))
//    }
//}



enum ViewState {
    case inactive
    case active
    case dismissed
}
