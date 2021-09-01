//
//  NewFoodEntry.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/24/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI

struct NewFoodEntry: View {
    @ObservedObject var foods = Foods()
    
    @Binding var isPresented: Bool
    @Binding var foodList: [Food]
    
    // Properties
    @State private var brandName: String = FoodEntryView.brandName.title()
    @State private var brandNameFieldColor: Color = .primary
    
    @State private var flavor: String = FoodEntryView.flavor.title()
    @State private var flavorFieldColor: Color = .primary
    
    @State private var amountGiven: String = ""
    @State private var amountGivenFieldColor: Color = .primary
    @State private var measurementType: MeasurementType = .teaSpoon
    
    
    @State private var isFavorite: Bool = false 
    
    // Saving parameters
    @State private var saveState: SaveState = .standard
    @State private var saveWasPressed: Bool = false
    @State private var saveButtonColor: Color = .gray
    
    
    
    
    var body: some View {
        
        HStack {
            Button {
                self.isPresented.toggle()
            } label: {
                Text("Cancel")
                    .foregroundColor(.red)
                    .padding()
            }
            Spacer()
        }
        
        Form {
            if #available(iOS 14.0, *) {
                TextField(FoodEntryView.brandName.title(),
                          text: $brandName)
                    .foregroundColor(brandNameFieldColor)
                    .padding()
                    .onChange(of: brandName, perform: { value in
                        updateSaveState()
                        if brandNameFieldColor == .red {
                            brandName = ""
                            brandNameFieldColor = .primary
                        }
                    })
                
                TextField(FoodEntryView.flavor.title(), text: $flavor)
                    .foregroundColor(flavorFieldColor)
                    .padding()
                    .onChange(of: flavor, perform: { value in
                        if flavorFieldColor == .red {
                            updateSaveState()
                            flavorFieldColor = .primary
                        }
                    })
                
                //                TextField(FoodEntryView.amount.title(), text: $amountGiven)
                //
                //
                TextField(FoodEntryView.amount.title(),
                          text: $amountGiven)
                    .foregroundColor(amountGivenFieldColor)
                    .keyboardType(.decimalPad)
                    .padding()
                    .onChange(of: amountGiven, perform: { value in
                        if amountGivenFieldColor == .red {
                            updateSaveState()
                            amountGivenFieldColor = .primary
                        }
                    })
                MeasurementRow(measurement: $measurementType)
                    .padding(.vertical)
                
                Section(header: Text("Favorite").textCase(.none)) {
                    // MARK: Set Favorite
                    
                    ToggleRow(title: "Mark as favorite",
                              isOn: $isFavorite)
                        .font(.body)
                        .padding()
                }
            } else {
                // Fallback on earlier versions
            }
            
            Section {
                saveButton()
            }
        }
        
    }
    
    
}


// Saving
extension NewFoodEntry {
    
    func saveEntry() {
        var measurement: FoodMeasurement {
            let amount = Int(amountGiven) ?? 0
            let measure = measurementType
            
            return FoodMeasurement(amount: amount,
                                   measurement: measure)
            
        }
        
        
        
        
        let favorite = foods.convertToFavoriteKey(isFavorite)

        guard let food = foods.createNewFood(name: brandName,
                            flavor: flavor,
                            defaultAmount: measurement,
                            favorite: favorite) else { return }
        foodList.append(food)
        
        // Dismiss View
        self.isPresented = false
        
    }
    
    func saveButton() -> some View {
        Button {
            saveWasPressed = true
            updateSaveState()
            
            switch saveState {
            case .accepted:
                saveEntry() 
                break
            case .denied:
                saveButtonColor = .red
            case .standard:
                break
            }
            
        } label: {
            Text("Save")
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(saveButtonColor)
                .foregroundColor(Color.white)
                .font(.headline)
                
                .cornerRadius(15)
                .shadow(radius: 2)
            
        }
        
    }
    
    private func detectIncompleteViews() -> [FoodEntryView] {
        var views: [FoodEntryView] = []
        
        if brandName == FoodEntryView.brandName.title() ||
            brandName == "" {
            views.append(.brandName)
        }
        
        if flavor == FoodEntryView.flavor.title() ||
            flavor == "" {
            views.append(.flavor)
        }
        
        if amountGiven == FoodEntryView.amount.title() ||
            amountGiven == "" {
            views.append(.amount)
            
            print("AmountGiven: \(amountGiven)")
        }
        
        return views
    }
    
    private func disableSaving() {
        if saveWasPressed == true {
            saveState = .denied
        } else {
            saveState = .standard
        }
        saveButtonColor = saveState.color()
    }
    
    private func setTextFieldsToDefaultColors() {
        brandNameFieldColor = .primary
        flavorFieldColor = .primary
        amountGivenFieldColor = .primary
    }
    
    private func updateSaveState() {
        let incompleteViews = detectIncompleteViews()
        
        if incompleteViews.count != 0  {
            // deny
            disableSaving()
            for view in incompleteViews {
                switch view {
                case .brandName:
                    brandNameFieldColor = .red
                case .flavor:
                    flavorFieldColor = .red
                case .amount:
                    amountGivenFieldColor = .red
                }
            }
        } else {
            // accept
            saveState = .accepted
            saveButtonColor = saveState.color()
            setTextFieldsToDefaultColors()
        }
    }
    
    
}



enum FoodEntryView {
    case brandName
    case flavor
    case amount
    
    func title() -> String {
        switch self {
        case .brandName:
            return "Brand Name"
        case .flavor:
            return "Flavor"
        case .amount:
            return "Amount"
            
        }
    }
}

struct NewFoodEntry_Previews: PreviewProvider {
    static var previews: some View {
        NewFoodEntry(foods: Foods(),
                     isPresented: .constant(true),
                     foodList: .constant([]))
    }
}
