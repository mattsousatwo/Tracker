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
    @State private var foodList = [Food]()

    @State private var createNewFoodIsPresented = false
     
    @State private var presentFoodDetail: Bool = false
    
    var body: some View {
        
        if #available(iOS 14.0, *) {
            
                foodsList()
                
//
//            List {
//                ForEach(foodList, id: \.self) { food in
//
//                    foodNavigationLink(food)
//
//
//                }.onDelete(perform: deleteFoodRow)
//
//            }
//
            
            .onAppear {
                loadFoods()
            }
            .onReceive(foods.$allFoods, perform: { (allFoods) in
                updateFoodsList(with: allFoods)
            })
            .onChange(of: presentFoodDetail, perform: { _ in
                if presentFoodDetail == false {
                    loadFoods()
                }
            })
            .onChange(of: foods.allFoods, perform: { newValue in
                updateFoodsList(with: newValue)
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

// Foods List
extension AllFoodsList {
    
    // inital Load
    func loadFoods() {
//        foodList = foods.getAllFoods()
        
        foods.fetchAll()
    }
    
    // Reload on dismiss of food detail
    func updateFoodsList(with foods: [Food]) {
        foodList.removeAll()
        foodList = foods
    }
    
    // Foods List
    func foodsList() -> some View {
        List {
            ForEach(foodList, id: \.self) { food in
                
                foodNavigationLink(food)
                
            }.onDelete(perform: deleteFoodRow)
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
    
    // Delete Row
    func deleteFoodRow(at offsets: IndexSet) {
        guard let fristOffset = offsets.first else { return }
        let food = foodList[fristOffset]
        guard let foodID = food.uuid else { return }
        
        foods.deleteSpecificElement(.food, id: foodID)
        foodList.removeAll(where: { $0.uuid == foodID })
        
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
}


struct AllFoodsList_Previews: PreviewProvider {
    static var previews: some View {
        AllFoodsList()
    }
}
 
