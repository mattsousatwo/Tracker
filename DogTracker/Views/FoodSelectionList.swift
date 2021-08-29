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
    
    
    
    @State var createNewFoodIsPresented: Bool = false
    
    
    
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
                if foods.allFoods.count == 0 {
                    createNewFoodButton()
                }
            }
            .onChange(of: foodList) { (_) in
                updateFavoriteSelection()
            }
            .onAppear {
                foodList = foods.getAllFoods()
                
                if foods.allFoods.count == 0 {
                    createNewFoodIsPresented = true
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
                        
                        
               
                    }
                    
                    
                }
            } .onDelete(perform: deleteFoodRow)
    }
    
    func deleteFoodRow(at offsets: IndexSet) {
        
        let s = foodList[offsets.first!]
        print(s.name!)
        
        
    }
    
    
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
