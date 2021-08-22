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
    
    
    @State var selectedFood: [Food] = []
    
    
    @State var createNewFoodIsPresented: Bool = false
    
    
    
    var body: some View {
        
        HStack {
            cancelButton()
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
            
            .onAppear {
                foodList = foods.getAllFoods()
                if foods.allFoods.count == 0 {
                    createNewFoodIsPresented = true
                }
            }
  
        } else {
            // Fallback on earlier versions
        }
    }
    
    /// For each food in foodList produce a TextView
    func allFoodsList() -> some View {
        return
            ForEach(foodList, id: \.self) { food in
                if let foodsName = food.name {
                    Button {
                        favoriteFood = food
                        isPresented = false
                    } label: {
                        Text(foodsName).tag(food)
                            .foregroundColor(.primary)
                            .padding()
                    }
                    
                    
                }
            }
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
//
//struct FoodSelectionList_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodSelectionList(favoriteFood: .constant("P"), isPresented: .constant(true))
//    }
//}
