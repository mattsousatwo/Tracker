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
    @State private var bathroomMode = true
    
    var bathroomTypes: [EntryType] = [.pee, .poop, .vomit]
    var foodTypes: [EntryType] = [.food, .water]
    
    
    @State private var selectedMeasurment: MeasurmentType = .teaSpoon
    var measurements: [MeasurmentType] = [.teaSpoon, .tableSpoon, .fluidOunce, .cup, .pint, .quart]
    
    
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

                            Toggle(isOn: $bathroomMode,
                                   label: {
                                    HStack {
                                        Text("Primary")
                                        Spacer()
//                                        Text(bathroomMode ? "Bathroom Mode": "Food Mode")

                                    }

                                   })
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                            .padding(.bottom, 5)
                        
                ) {
                    
                    typePicker()
                        .onChange(of: bathroomMode, perform: { value in
                            type = 0
                        })
                    
                    timeRow()
                    
                }
                
                
                Section(header: Text("Select Dog")) {
                    
                    selectDog()
                    
                }
                
                // Extras
                // Set secondary information
                if bathroomMode == true {
                    bathroomModeSecondary()
                } else if bathroomMode == false {
                    foodModeSecondary()
                }
                
                
                saveButton()
                
                
                
                
            }
            .onAppear {
                displayExtraSettings = userDefaults.displayExtras()
                if let favoriteDog = dogs.fetchFavoriteDog() {
                    favorite = favoriteDog
                }
            }
            .navigationBarTitle(Text(bathroomMode ? "Bathroom Mode" : "Food Mode "))
        } else {
            // Fallback on earlier versions
        }
        
    } // Body
    
    
    func saveButton() -> some View {
        return
            Section {
                // Save button - TESTING - go to SwiftUIView
                Button("Save") {
                    
                    if bathroomMode == true {
                        /// Newly created BathroomEntry
                        guard let newEntry = bathroomBreak.createNewEntry() else { return }

                        var selectedType: Int16 {
                            switch bathroomMode {
                            case true:
                                let bathroomType = bathroomTypes[type]
                                return bathroomType.asInt
                            case false:
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
                        
                    } else {
                        if let favorite = favorite {
                            foodEntries.createNewEntry(foodID: favoriteFood?.uuid ?? "",
                                                       amount: Int16(amountGiven) ?? 0,
                                                       date: setTime,
                                                       notes: notes,
                                                       dogID: favorite.uuid,
                                                       type: foodTypes[type])
                            
//                            print("\nNew Food Entry - \(foodEntries.entries.count) - \nfoodID: \(foodEntries.entries.last?.foodID ?? "nil"),\ndate: \(foodEntries.entries.last?.date ?? "dnil"),\namountGiven: \(foodEntries.entries.last?.amount)\n")
                        }
                    }
                    
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .font(.headline)
                
                .cornerRadius(15)
                .shadow(radius: 2)

            }
    }
    
    func timeRow() -> some View {
        return
            HStack {
                Icon(image: "clock", color: .androidGreen)
                
                // Set Time for entry
                DatePicker("Set Time", selection: $setTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .padding()
            }
    }
    
    func typePicker() -> some View {
        return
            // Set entry type
            Picker(selection: $type, label: Text("") , content: {
                
                if bathroomMode == true {
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
                } else {
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
        return
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
        return                 Button {
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
        return
            Section(header: Text("Secondary") ) {
                // Notes feild
                TextField("Notes", text: $notes)
                    .padding()
                if bathroomMode == true {
                    extraList()
                    // Open Extra Parameters
                    if displayExtraSettings == true {
                        ToggleRow(icon: "pills",
                                  color: .darkGreen,
                                  title: "Treat",
                                  isOn: $treat)
                            .padding()
//                            .animation(.default)
                        ToggleRow(icon: "target",
                                  color: .darkGreen,
                                  title: "Correct Spot",
                                  isOn: $correctSpot)
                            .padding()
//                            .animation(.default)
                    }
                }
            }
    }
    
    func foodModeSecondary() -> some View {
        return
            Section(header: Text("Food Selection") ) {
                
                if bathroomMode == false {
                    
                    amountGivenRow()
                    
                    Button {
                        self.displayFoodList.toggle()
                    } label: {
                        HStack {
                            Spacer() 
                            // Use dog food name not favorite name
                            if let name = favoriteFood?.name {
                                Text(name)
                                    .foregroundColor(.primary)
                            } else {
                                Text("Create New Food")
                                    .foregroundColor(.blue)
                            }
                            
                            Spacer()
//                            Image(systemName: "chevron.right")
//                                .padding()
//
                        }
                    }
                    .padding()
                    .onAppear {
                        
                        favoriteFood = foods.getFavoriteFood()
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
    
    func amountGivenRow() -> some View {
        return
            VStack {
                HStack {
                    Icon(image: "scalemass", color: .lightOrange)
                    
//                    TextField("Amount Given", text: $amountGiven)
//                        .keyboardType(.decimalPad)
//                        .padding()
                    
                    if #available(iOS 14.0, *) {
                        TextField("Title", text: $amountGiven)
                            .keyboardType(.decimalPad)
                            .padding()
                    }
                    
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            Text("Navigate")
                                .buttonStyle(PlainButtonStyle() )
                        })
                        
                    
                }
                Divider()
                // segmeny bar
                measurementPicker()
            }
    }
    
    
    func measurementPicker() -> some View {
        return
            // Set entry type
            Picker(selection: $selectedMeasurment, label: Text("") , content: {
                

                ForEach(MeasurmentType.allCases, id: \.rawValue) { measurment in
                        Text(measurment.rawValue).tag(measurment)
                            .padding()
                    }
                
            })
            .pickerStyle(SegmentedPickerStyle())
            .padding()
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

enum MeasurmentType: String, CaseIterable, Codable {
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

//struct BathroomEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        BathroomEntryView()
//    }
//}
