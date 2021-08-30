//
//  EntryView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/21/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

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
    
    
    // For Testing in canvas
    var mode: Bool = true
    func testingUpdateMode() {
        entryModeToggle = mode
        switch mode {
        case true:
            entryMode = .bathroomMode
        case false:
            entryMode = .foodMode
        }
    }
    
    
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
    @State private var favorite: Dog?
    
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
    @State private var notes = ""
    // Treat Given
    @State private var treat: Bool = false
    // Photo
    
    // Food Properties
    // as well as time, notes, and dog are used
    @State private var amountGiven: String = ""
    
    
    
    
    
    // Body
    var body: some View {
        
        if #available(iOS 14.0, *) {
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
                if let favoriteDog = dogs.fetchFavoriteDog() {
                    favorite = favoriteDog
                }
                testingUpdateMode()
            }
            .navigationBarTitle(Text(entryModeToggle ? "Bathroom Mode" : "Food Mode"))
        } else {
            // Fallback on earlier versions
        }
        
    } // Body
    
    
    func saveButton() -> some View {
        Section {
            // Save button - TESTING - go to SwiftUIView
            Button("Save") {
                
                switch entryMode {
                case .bathroomMode:
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
                    
                    if let favorite = favorite {
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
                    
                case .foodMode:
                    if let favorite = favorite {
                        foodEntries.createNewEntry(foodID: favoriteFood?.uuid ?? "",
                                                   amount: Int16(amountGiven) ?? 0,
                                                   date: setTime,
                                                   notes: notes,
                                                   dogID: favorite.uuid,
                                                   type: foodTypes[type])
                        
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
        // Set entry type
        Picker(selection: $type, label: Text("") , content: {
            switch entryMode {
            case .bathroomMode:
                ForEach(0..<bathroomTypes.count) { index in
                    switch discreteMode {
                    case true:
                        if self.bathroomTypes[index] == .pee ||
                            self.bathroomTypes[index] == .poop ||
                            self.bathroomTypes[index] == .vomit {
                            Text(self.bathroomTypes[index].discreteMode!).tag(index)
                                .padding()
                        } else {
                            Text(self.bathroomTypes[index].rawValue).tag(index)
                                .padding()
                        }
                        
                    case false:
                        Text(self.bathroomTypes[index].rawValue).tag(index)
                            .padding()
                        
                    }
                }
            case .foodMode:
                ForEach(0..<foodTypes.count) { index in
                    Text(self.foodTypes[index].rawValue).tag(index)
                        .padding()
                }
            }
        })
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onAppear {
                discreteMode = userDefaults.discreteMode()
            }
        
    }
    
    func extraList() -> some View {
        Button(action: {
            withAnimation {
                self.displayExtraSettings.toggle()
            }
        }, label: {
            
            HStack {
                
                Text("Extras").font(.subheadline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .frame(width: 20, height: 20)
                    .padding(5)
                    .rotationEffect(displayExtraSettings ? .degrees(90) : .degrees(0))
                //                        .animation(displayExtraSettings ? .default : nil)
                
            }
            
        })
            .foregroundColor(.primary)
            .padding()
    }
    
    func selectDog() -> some View {
        Button {
            self.displaySelectDogView.toggle()
        } label: {
            //                    DogRow(dog: favorite).frame(height: 100)
            if let favorite = favorite,
               let name = favorite.name {
                switch favorite.isFavorite {
                case 1:
                    Text(name)
                        .foregroundColor(.blue)
                default:
                    Text(name)
                        .foregroundColor(.black)
                }
                
                
                
            }
            
        }
        .padding()
        .sheet(isPresented: $displaySelectDogView) {
            
            SelectDogList(favoriteDog: $favorite,
                          isPresented: $displaySelectDogView)
            
        }
        
        
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
                    HStack {
                        
                        Icon(image: "bag", color: .lightBlue)
                        Spacer()
                        // Use dog food name not favorite name
                        if let name = favoriteFood?.name {
                            Text(name)
                            //                                    .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .padding()
                        } else {
                            Text("Create New Food")
                                .foregroundColor(.blue)
                                .padding()
                        }
                        
                        
                        //                            Image(systemName: "chevron.right")
                        //                                .padding()
                        //
                    }
                    
                }
                
                
                
                if #available(iOS 14.0, *) {
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
                } else {
                    // Fallback on earlier versions
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
            HStack {
                Icon(image: "scalemass", color: .lightBlue)
                
                
                TextField("0", text: $amountGiven)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .padding()
                
            }
            Divider()
            // segmeny bar
            //                measurementPicker()
            
                MeasurementRow(measurement: $selectedMeasurment)
            
            
        }
    }
    
    func foodModeSecondary2() -> some View {
        Section(header: Text("Food Selection") ) {
            if entryMode == .foodMode {
                
                NavigationLink(isActive: $displayFoodList) {
                    FoodSelectionList(favoriteFood: $favoriteFood,
                                      isPresented: $displayFoodList)
                } label: {
                    HStack {
                        Icon(image: "bag",
                             color: .lightBlue)
                        Spacer()
                        if let name = favoriteFood?.name {
                            Text(name)
                                .foregroundColor(.primary)
                                .padding()
                        } else {
                            Text("Create New Food")
                                .foregroundColor(.lightBlue)
                                .padding()
                        }
                    }
                }
                
                amountGivenRow()
                
            }
            // Notes feild
            textView()
        }
        
    }
    
    
    func textView() -> some View {
        TextView(text: $notes)
            .frame(height: 250,
                   alignment: .center)
            .padding(.horizontal, 5)
    }
    
    
    
    
    
    
    
    
    
    enum EntryMode {
        case bathroomMode
        case foodMode
    }
    
    
    
    
} // EntryView


enum EntryType: String {
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

struct BathroomEntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(mode: false)
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            .previewDisplayName("iPhone 8")
        
    }
}
