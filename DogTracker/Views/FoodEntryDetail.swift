//
//  FoodEntryDetail.swift
//  FoodEntryDetail
//
//  Created by Matthew Sousa on 9/11/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct FoodEntryDetail: View {
    @Environment(\.presentationMode) var presentationMode
    
    var entry: FoodEntry
    let foods = Foods()
    let dogs = Dogs()
    let foodEntries = FoodEntries()
    @Binding var entries: [FoodEntry]
    @Binding var didDismiss: Bool
    
    @State private var date: Date = Date()
    
    @State private var notes: String = "Notes"
    @State private var type: String = ""
    @State private var amount: String = ""
    @State private var measurmentType: MeasurementType = .teaSpoon
    
    
    @State private var displayDogList: Bool = false
    @State private var assignedDog: Dog? = nil
    
    @State private var displayFoodList: Bool = false
    @State private var assignedFood: Food? = nil
    
    var body: some View {
        
        Form {
            Section {
                

                dogRow()
                
                dateRow()
                
                foodRow()
                
                TextFieldRow(image: "scalemass",
                             fieldString: $amount)
                MeasurementRow(measurement: $measurmentType)
                    .padding(.vertical)
                
            }
            
            
            Section {
                LargeTextView(text: $notes)
            } header: {
                Text("Notes")
            }
            
            deleteButton()

            
        }
        .onAppear {
            initalizeEntry()
        }
        .navigationTitle(Text("Details"))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    didDismiss = true
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                saveButton()
            }
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
}

/// Views
@available(iOS 14.0, *)
extension FoodEntryDetail {
    
    /// Date row
    func dateRow() -> some View {
        let components: DatePickerComponents = [.date, .hourAndMinute]
        return DateEntryRow(date: $date,
                     components: components)
    }
    
    
    /// Select food Row
    func foodRow() -> some View {
        var name = ""
        if let food = assignedFood {
            if let foodName = food.name {
                name = foodName
            }
        }
        
        
        return HStack {
            Button {
                self.displayFoodList.toggle()
            } label: {
                RowWithIcon(image: "bag") {
                    Spacer()
                    Text(name)
                        .padding()
                        .foregroundColor(.lightBlue)
                }
            }
            .sheet(isPresented: $displayFoodList) {
                FoodSelectionList(favoriteEditorIsOn: false,
                                  favoriteFood: $assignedFood,
                                  isPresented: $displayFoodList)
            }
            
            
            Image(systemName: "chevron.right")
        }
    }
    
    
    
    func dogRow() -> some View {
        return SelectDogRow(dog: $assignedDog,
                            displaySheet: $displayDogList)
    }
    
    
    
    /// Save Button View
    func saveButton() -> some View {
        Button {
            saveFunction()
        } label: {
            Text("Save")
                .padding()
        }
    }
    
    /// Delete Button View
    func deleteButton() -> some View {
        Button {
            
            self.presentationMode.wrappedValue.dismiss()
            guard let foodID = entry.uuid else { return }
            entries.removeAll(where: { $0.uuid == foodID })
            foodEntries.deleteSpecificElement(.foodEntry, id: foodID)
            
        } label: {
            Text("Delete Entry")
                .foregroundColor(.red)
                .padding()
        }
        
    }

}

/// Methods
@available(iOS 14.0, *)
extension FoodEntryDetail {
    
    // Load inital values
    func initalizeEntry() {
        unwrapDogID()
        
        if let measurement = entry.measurement {
            if let foodGiven = foods.decodeToFoodMeasurement(string: measurement) {
                amount = "\(foodGiven.amount)"
                self.measurmentType = foodGiven.measurement
            }
            
        }
        
            
        if let entryNotes = entry.notes {
            notes = entryNotes
        }
        type = "\(entry.type)"
        
        getFood()
        getDate()
        
    }
    
    /// Update Detail
    func saveFunction() {
        guard let dogID = assignedDog?.uuid else { return }
        guard let food = assignedFood else { return }
        guard let foodID = food.uuid else { return }
        let foodGiven = FoodMeasurement(amount: amount,
                                        measurement: measurmentType)
        entry.update(foodID: foodID,
                     measurement: foodGiven,
                     date: date,
                     notes: notes,
                     dogID: dogID)
    }
    
    // Fetch food for entry
    func getFood() {
        guard let foodID = entry.foodID else { return }
        assignedFood = foods.fetchFood(id: foodID)
    }
    
    /// Convert entry date String to Date
    func getDate() {
        guard let dateString = entry.date else { return }
        let formatter = DateControllerProvider()
        guard let newDate = formatter.convertStringToDate(dateString) else { return }
        date = newDate
    }

    /// Fetch dog for entry
    func unwrapDogID() {
        guard let dogID = entry.dogID else { return }
        self.assignedDog = dogs.fetchDog(id: dogID)
    }
    
}


//
//struct FoodEntryDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodEntryDetail()
//    }
//}
