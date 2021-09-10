//
//  FoodDetailView.swift
//  FoodDetailView
//
//  Created by Matthew Sousa on 8/30/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI


@available(iOS 14.0, *)
struct FoodDetailView: View {
    @Environment(\.presentationMode) var mode
    
    var food: Food
    @Binding var isPresented: Bool
    
    // Food Properties
    @State private var name: String = "Name"
    @State private var foodFlavor: String = "Flavor"
    @State private var defaultAmount: String = "0"
    @State private var measurementType: MeasurementType = .teaSpoon
    @State private var isFavorite: Bool = false
    
    
    var body: some View {
        List {
            TextField(name, text: $name)
                .padding()
                .onAppear {
                    setValuesOnAppear()
                }
            TextField("Flavor", text: $foodFlavor)
                .padding()
            
            
            Section(header: Text("Default Amount")) {
                TextField("Amount:", text: $defaultAmount)
                    .padding()
                    .keyboardType(.decimalPad)
                MeasurementRow(measurement: $measurementType)
                    .padding(.vertical)
            }
            
            
            Section(header: Text("Favorite")) {
                ToggleRow(title: "Set as Favorite",
                          isOn: $isFavorite)
                    .padding()
            }
            
            Section(header: Text("History")) {
                    foodHistoryRow()
            }
        }

        .navigationTitle(Text(name))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                saveButton()
            }
        }
    }
    
}

// Views
@available(iOS 14.0, *)
extension FoodDetailView {
    
    /// Navigation Bar button to save the selected foods details
    func saveButton() -> some View {
        Button {
            updateFood()
            mode.wrappedValue.dismiss()
            self.isPresented = false
        } label: {
            Text("Save")
        }
    }
    
    /// Row to segue to selected foods history
    func foodHistoryRow() -> some View {
        return NavigationLink {
            FoodHistory(food: food)
        } label: {
            Text("Food entries")
                .padding()
        }
    }
    
}

// Methods
@available(iOS 14.0, *)
extension FoodDetailView {
    
    /// Update food properties & save
    func updateFood() {
        let foods = Foods()
        food.update(name: name,
                    flavor: foodFlavor)
        
        let fav = foods.convertToFavoriteKey(isFavorite)
        if fav == FavoriteKey.isFavorite {
            foods.setFavoriteFood(as: food)
        }
        
        guard let amount = Int(defaultAmount) else { return }
        let measurment = FoodMeasurement(amount: amount,
                                         measurement: measurementType)
        food.update(defaultAmount: measurment)
        
    }
    
    /// Set State values as selected foods properties
    func setValuesOnAppear() {
        
        if let foodName = food.name {
            name = foodName
        }
        
        if let flavor = food.flavor {
            foodFlavor = flavor
        }
        
        let amount = food.decodeDefaultAmount()
        defaultAmount = "\(amount.amount)"
        measurementType = amount.measurement
        
        isFavorite = food.favorite()
    }
    
}

//struct FoodDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodDetailView()
//    }
//}
