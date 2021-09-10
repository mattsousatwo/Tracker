//
//  AllFoodsList.swift
//  AllFoodsList
//
//  Created by Matthew Sousa on 8/29/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct AllFoodsList: View {
    
    @ObservedObject var foods = Foods()
    /// List of Foods in View
    @State private var foodList = [Food]()
    /// Count of Foods in FoodList - will determine if create new food button is displayed or list of foods
    @State private var foodCount: Int = 0
    
    /// Trigger new food creation
    @State private var createNewFoodIsPresented = false
    ///  Go to Food Detail View 
    @State private var presentFoodDetail: Bool = false
    
    
    
    var body: some View {
        
        if #available(iOS 14.0, *) {
            
                foodsList()

            .onAppear {
                loadFoods()
                
            }
            .onReceive(foods.$allFoods, perform: { (allFoods) in
                updateFoodsList(with: allFoods)
                if foodList.count == 1 {
                    
                }
            })
            .onChange(of: presentFoodDetail, perform: { _ in
                if presentFoodDetail == false {
                    loadFoods()
                }
            })
            .onChange(of: foods.allFoods, perform: { newValue in
                updateFoodsList(with: newValue)
            })
            .onChange(of: createNewFoodIsPresented, perform: { _ in
                loadFoods()
            })
            
            .navigationBarTitle(Text("Food List"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addFoodButton()
                }
            }
        }
        
    }
    
}

// Views
extension AllFoodsList {
    
    // Foods List
    func foodsList() -> some View {
        List {
            
            switch foodCount {
            case 0:
                createNewFoodButton()
            default:
                ForEach(foodList, id: \.self) { food in
                    
                    foodNavigationLink(food)
                    
                }.onDelete { index in
                    foods.deleteFood(at: index,
                                     in: foodList,
                                     onDelete: delete(at: index),
                                     onLastDelete: onLastDelete())
                    
                }
                //            .onDelete(perform: deleteFoodRow)
            }
        }
    }
    
    // Link to FoodDetailView
    func foodNavigationLink(_ food: Food) -> some View {
        
        return NavigationLink(destination: {
            if #available(iOS 14.0, *) {
                FoodDetailView(food: food,
                               isPresented: $presentFoodDetail)
            }
        }) {
            if let name = food.name {
                switch food.favorite() {
                case true:
                    foodListRow(name,
                                color: .lightBlue)
                case false:
                    foodListRow(name,
                                color: .primary)
                }
            }
        }
    }

    
    // Food List Row
    func foodListRow(_ title: String, color: Color) -> some View {
        Text(title)
            .foregroundColor(color)
            .padding()
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
    
    /// Create new food text button
    func createNewFoodButton() -> some View {
        return
            Button {
                createNewFoodIsPresented.toggle()
            } label: {
                Text("Create new food")
                    .padding()
            }
    }
}

// Methods
extension AllFoodsList {
    
    // inital Load
    func loadFoods() {
        foods.fetchAll()
    }
    
    // Reload on dismiss of food detail
    func updateFoodsList(with foods: [Food]) {
        foodList.removeAll()
        foodList = foods
        foodCount = foodList.count
    }
    
}

// Methods - Deleting
extension AllFoodsList: FoodList {
    
    func delete(at set: IndexSet) {
        guard let index = set.first else { return }
        foodList.remove(at: index)
        foodCount = foodList.count
    }
    
    func onLastDelete() {
        // Display empty message
    }
    
    func updateFavoriteSelection() {
        
    }
    
    func replaceFavoriteSelection(at index: Int) {
        
    }
    
}

struct AllFoodsList_Previews: PreviewProvider {
    static var previews: some View {
        AllFoodsList()
    }
}
 
