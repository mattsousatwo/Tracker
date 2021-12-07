//
//  EntryView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/21/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct EntryView: View {
    
    // Coredata classes
    let bathroomBreak = BathroomBreak()
    let dogs = Dogs()
    @ObservedObject var foods = Foods()
    @ObservedObject var foodEntries = FoodEntries()
    let userDefaults = UserDefaults()
    
    /// [BathroomMode: true], [FoodMode: false]
    @State private var entryModeToggle = true
    @State private var entryMode: EntryMode = .bathroomMode
    
    var bathroomTypes: [EntryType] = [.pee, .poop, .vomit]
    var foodTypes: [EntryType] = [.food, .water]
    
    
    @State private var selectedMeasurment: MeasurementType = .teaSpoon
    var measurements: [MeasurementType] = [.teaSpoon, .tableSpoon, .fluidOunce, .cup, .pint, .quart]
    
    
    // Display; Gave Treat, Correct Spot, Photo Option,
    @State private var displayExtraSettings = false
    /// Display select dog list
    @State private var displaySelectDogView = false
    /// Display Food List
    @State private var displayFoodList = false
    
    @State private var discreteMode = false
    
    /// Favorite dog - Passed to SelectDogList to choose dog that will be linked to bathroom entry / food entry
    @State private var favoriteDog: Dog?
    @State private var favoriteDogName: String?
    
    
    /// Food that will be assigned to the FoodEntry
    @State var favoriteFood: Food?
    
    
    // Bathroom Properties
    // Time
    @State private var setTime = Date()
    // Bathroom Type
    @State private var type = 0
    // Correct Spot
    @State private var correctSpot: Bool = false
    // Notes
    @State private var notes = "Notes"
    // Treat Given
    @State private var treat: Bool = false
    // Photo
    
    // Food Properties
    // as well as time, notes, and dog are used
    @State private var amountGiven: String = ""
    
    // Missing Properties
    @State var favoriteDogColor: Color? = .lightBlue
    @State var favoriteFoodColor: Color = .lightBlue
    @State var amountGivenColor: Color = .primary
    
    // Body
    var body: some View {
        
        
        Form {
            // Main information
            
            Section(header:
                        
                        Toggle(isOn: $entryModeToggle,
                               label: {
                HStack {
                    Text("Primary")
                    Spacer()
                    
                }
                
            })
                        .toggleStyle(SwitchToggleStyle(tint: .lightBlue))
                        .padding(.bottom, 5)
                    
            ) {
                
                typePicker()
                    .onChange(of: entryModeToggle, perform: { value in
                        type = 0
                        switch value {
                        case true:
                            entryMode = .bathroomMode
                        case false:
                            entryMode = .foodMode
                        }
                    })
                
                timeRow()
                
            }
            .onAppear {
                if let fetchedDog = dogs.fetchFavoriteDog() {
                    favoriteDog = fetchedDog
                    favoriteDogName = fetchedDog.name
                }
                
            }
            
            
            Section(header: Text("Select Dog")) {
                
                selectDog()
                
            }
            
            // Extras
            // Set secondary information
            switch entryMode {
            case .bathroomMode:
                bathroomModeSecondary()
            case .foodMode:
                foodModeSecondary()
                //                    foodModeSecondary2()
            }
            
            
            
            saveButton()
            
            
            
            
        }
        .onAppear {
            displayExtraSettings = userDefaults.displayExtras()
        }
        .onChange(of: favoriteDog?.name) { newValue in
            favoriteDogName = newValue
        }
        .onChange(of: favoriteDog) { newValue in
            if let name = favoriteDog?.name {
                favoriteDogName = name
            }
        }
        
        .navigationBarTitle(Text(entryModeToggle ? "Bathroom Mode" : "Food Mode"))
        
        
    } // Body
    
    
    func saveBathroomEntry() {
        /// Newly created BathroomEntry
        guard let newEntry = bathroomBreak.createNewEntry() else { return }
        
        var selectedType: Int16 {
            switch entryMode {
            case .bathroomMode:
                let bathroomType = bathroomTypes[type]
                return bathroomType.asInt
            case .foodMode:
                let foodType = foodTypes[type]
                return foodType.asInt
            }
        }
        
        if let favorite = favoriteDog {
            /// Update & Save newly created BathroomEntry
            self.bathroomBreak.update(entry: newEntry,
                                      correctSpot: correctSpot,
                                      notes: self.notes,
                                      date: setTime,
                                      dogUUID: favorite.uuid,
                                      treat: treat,
                                      type: selectedType )
            
            print("BathroomBreak Saved! - \(newEntry)")
        }
        
    }
    
    func saveFoodEntry() {
        if let favorite = favoriteDog {
            let amount = FoodMeasurement(amount: amountGiven,
                                         measurement: selectedMeasurment)
            foodEntries.createNewEntry(foodID: favoriteFood?.uuid ?? "",
                                       measurement: amount,
                                       date: setTime,
                                       notes: notes,
                                       dogID: favorite.uuid,
                                       type: foodTypes[type])
        }

    }
    
    
    func allFieldsPass() -> Bool {
        switch entryMode {
        case .bathroomMode:
            if favoriteDog == nil {
                print("allFieldsPass() -> False: Favorite Dog is nil")
                return false
            }
        case .foodMode:
            if favoriteFood == nil {
                print("allFieldsPass() -> False: Favorite Food is nil")
                return false
            }
            if amountGiven == "" {
                print("allFieldsPass() -> False:  amountGiven == \("")")
                return false
            }
            if amountGiven == "0" {
                print("allFieldsPass() -> False: amountGiven == 0")
                return false
            }
        }
        
        
        return true
    }
    
    func highlightMissingViews() {
        switch entryMode {
        case .bathroomMode:
            if favoriteDog == nil {
                favoriteDogColor = .red
            }
        case .foodMode:
            if favoriteFood == nil {
                favoriteFoodColor = .red
            }
            if amountGiven == "" ||
                amountGiven == "0" ||
                amountGiven == " " {
                
                amountGivenColor = .red
                
            }
     
        }
    }
    
    func saveButton() -> some View {
        Section {
            // Save button - TESTING - go to SwiftUIView
            Button("Save") {
                switch entryMode {
                case .bathroomMode:
                    
                    if allFieldsPass() == true {
                        saveBathroomEntry()
                    } else {
                        highlightMissingViews()
                    }
                    
                    
                case .foodMode:
                    let pass = allFieldsPass()
                    if pass == true {
                        saveFoodEntry()
                    } else {
                        highlightMissingViews()
                    }
                    
                }
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.lightBlue)
            .foregroundColor(Color.white)
            .font(.headline)
            
            .cornerRadius(15)
            .shadow(radius: 2)
            
        }
    }
    
    func timeRow() -> some View {
        HStack {
            Icon(image: "clock", color: .lightBlue)
            
            Spacer()
            
            // Set Time for entry
            DatePicker("Set Time", selection: $setTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .padding()
        }
    }
    
    func typePicker() -> some View {
        EntryTypePicker(entryMode: $entryMode,
                        type: $type)
    }
    
    
    func extraList() -> some View {
        DisplayListToggleRow(title: "Extras",
                             displayList: $displayExtraSettings)
            .foregroundColor(.primary)
            .padding()
    }
    
    
    func selectDog() -> some View {
        SelectDogRow(dog: $favoriteDog,
                     displaySheet: $displaySelectDogView,
                     displayColor: $favoriteDogColor,
                     favoriteEditor: true)
    }
    
    
    
    
    func bathroomModeSecondary() -> some View {
        Section(header: Text("Secondary") ) {
            if entryMode == .bathroomMode {
                extraList()
                // Open Extra Parameters
                if displayExtraSettings == true {
                    ToggleRow(icon: "pills",
                              color: .lightBlue,
                              title: "Treat",
                              isOn: $treat)
                        .padding()
                    //                            .animation(.default)
                    ToggleRow(icon: "target",
                              color: .lightBlue,
                              title: "Correct Spot",
                              isOn: $correctSpot)
                        .padding()
                    //                            .animation(.default)
                }
            }
            // Notes feild
            textView()
        }
    }
    
    func foodModeSecondary() -> some View {
        Section(header: Text("Food Selection") ) {
            
            if entryMode == .foodMode {
                
                
                
                Button {
                    self.displayFoodList.toggle()
                } label: {
                        RowWithIcon(image: "bag") {
                            Spacer()
                            
                            if let name = favoriteFood?.name {
                                Text(name)
                                    .foregroundColor(.primary)
                                    .padding()
                            } else {
                                Text("Create New Food")
                                    .foregroundColor(favoriteFoodColor)
                                    .padding()
                            }

                        }
                        
                        //                            Image(systemName: "chevron.right")
                        //                                .padding()
                        //
                    
                }
                
                
                
                
                amountGivenRow()
                
                    .onChange(of: favoriteFood) { newValue in
                        updateFoodMeasurements()
                    }
                    .onAppear {
                        
                        favoriteFood = foods.getFavoriteFood()
                        updateFoodMeasurements()
                    }
                    .sheet(isPresented: $displayFoodList) {
                        FoodSelectionList(favoriteFood: $favoriteFood,
                                          isPresented: $displayFoodList)
                        
                    }
                
                
                
            }
            
            
            // Notes feild
            TextField("Notes", text: $notes)
                .padding()
            
        }
    }
    
    /// Update Food Name and Measurements
    func updateFoodMeasurements() {
        if let favoriteFood = favoriteFood {
            let defaultAmount = favoriteFood.decodeDefaultAmount()
            amountGiven = "\(defaultAmount.amount)"
            selectedMeasurment = defaultAmount.measurement
            
        }
        
    }
    
    
    func amountGivenRow() -> some View {
        VStack {
            
            TextFieldRow(image: "scalemass",
                         placeholder: "amount",
                         fieldString: $amountGiven,
                         keyboardType: .decimalPad,
                         textAlignment: .trailing)
                .foregroundColor(amountGivenColor)
            
            Divider()
                MeasurementRow(measurement: $selectedMeasurment)
                .padding(.vertical)
            
            
        }
    }
   
    /// View for handling notes
    func textView() -> some View {
        LargeTextView(text: $notes)
    }
    
    

    
} // EntryView

enum EntryMode {
    case bathroomMode
    case foodMode
}

enum EntryType: String, CaseIterable, Identifiable {
    
    
    case pee = "Pee"
    case poop = "Poop"
    case vomit = "Vomit"
    case food = "Food"
    case water = "Water"
    
    var asInt: Int16 {
        switch self {
        case .pee:
            return 0
        case .poop:
            return 1
        case .vomit:
            return 2
            
        case .food:
            return 3
        case .water:
            return 4
        }
    }
    
    var discreteMode: String? {
        switch self {
        case .pee:
            return "1"
        case .poop:
            return "2"
        case .vomit:
            return "3"
        default:
            return nil
        }
    }
    
    var id: Int {
        switch self {
        case .pee:
            return 0
        case .poop:
            return 1
        case .vomit:
            return 2
        case .food:
            return 3
        case .water:
            return 4    
        }
    }
    
    var isFoodType: Bool {
        switch self {
        case .pee, .poop, .vomit:
            return false
        case .food, .water:
            return true
        }
    }
    
    var isBathroomType: Bool {
        if isFoodType == true {
            return false
        } else {
            return true 
        }
    }
    
}

enum MeasurementType: String, CaseIterable, Codable {
    case teaSpoon = "tsp."
    case tableSpoon = "Tbs."
    case fluidOunce = "fl. oz."
    case cup = "cup"
    case pint = "pt."
    case quart = "qt."
    //    case gallon = "gal."
    
    func value() -> Int {
        switch self {
        case .teaSpoon:
            return 0
        case .tableSpoon:
            return 1
        case .fluidOunce:
            return 2
        case .cup:
            return 3
        case .pint:
            return 4
        case .quart:
            return 5
        }
    }
}

@available(iOS 14.0, *)
struct BathroomEntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            .previewDisplayName("iPhone 8")
        
    }
}
