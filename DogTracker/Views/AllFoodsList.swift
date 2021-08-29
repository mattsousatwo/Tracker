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
    
    var body: some View {
        
        if #available(iOS 14.0, *) {
            List {
                foodsList()
                
            }
            .onAppear {
                loadOnAppear()
            }
            
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
    func loadOnAppear() {
        foodList = foods.getAllFoods()
    }
    
    // Foods List
    func foodsList() -> some View {
        ForEach(foodList, id: \.self) { food in
            if let foodsName = food.name {
                Button {
                    
                } label: {
                    switch food.isFavorite {
                    case FavoriteKey.isFavorite.rawValue:
                        foodListRow(foodsName,
                                    color: .lightBlue)
                    default:
                        foodListRow(foodsName,
                                    color: .primary)
                    }
                    
                    
                }
            }
            
        }.onDelete(perform: deleteFoodRow)
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
        let index = foodList[fristOffset]
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
 
