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
        }
        
        List {
            if selectedFood.count != 0 {
                allFoodsList()
            } else {
                createNewFoodButton()
            }
            
            
        }
        .onAppear {
            foodList = foods.getAllFoods()
        }
    }
    
    /// For each food in foodList produce a TextView
    func allFoodsList() -> some View {
        return
            ForEach(foodList, id: \.self) { food in
                if let foodsName = food.name {
                    Text(foodsName)
                        .padding()
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
                NewFoodEntry(isPresented: $createNewFoodIsPresented)
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
