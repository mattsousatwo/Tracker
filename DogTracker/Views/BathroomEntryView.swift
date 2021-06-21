//
//  BathroomEntryView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/21/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct BathroomEntryView: View {

    let bathroomBreak = BathroomBreak()
    
    enum EntryTypes: String {
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
            case .food:
                return 2
            case .water:
                return 3
            case .vomit:
                return 4
            }
        }
    }
    

    
    var bathroomTypes: [EntryTypes] = [.pee, .poop, .vomit]
    var foodTypes: [EntryTypes] = [.food, .water]
    
    // Display; Gave Treat, Correct Spot, Photo Option,
    @State private var displayExtraSettings = false
    /// Display select dog list
    @State private var displaySelectDogView = false
    
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
    
    @Binding var favorite: Dog
    
    let dogs = Dogs()
    
    @State private var bathroomMode = true
    
    
    // Body
    var body: some View {
        
        Form {
            // Main information
            if #available(iOS 14.0, *) {
                Section(header:
                            
                            
                            
                            Toggle(isOn: $bathroomMode,
                                   label: {
                                    HStack {
                                        Text("Main")
                                        Spacer()
                                        Text(bathroomMode ? "Bathroom Mode": "Food Mode")
                                            
                                    }
                                    
                                   })
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        
                        
                ) {
                    Group {
                        
                        // Set entry type
                        Picker(selection: $type, label: Text("") , content: {
                            
                            if bathroomMode == true {
                                ForEach(0..<bathroomTypes.count) { index in
                                    Text(self.bathroomTypes[index].rawValue).tag(index)
                                        .padding()
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
                        .onChange(of: bathroomMode, perform: { value in
                            type = 0
                        })
                        
                    }
                    
                    
                    HStack {
                        Icon(image: "clock", color: .androidGreen)
                        
                        // Set Time for entry
                        DatePicker("Set Time", selection: $setTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .padding()
                    }
                    
                }
            } else {
                // Fallback on earlier versions
            }
            
            Section(header: Text("Select Dog")) {
                
                Button {
                    self.displaySelectDogView.toggle()
                } label: {
                    //                    DogRow(dog: favorite).frame(height: 100)
                    if let name = favorite.name {
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
                
                .sheet(isPresented: $displaySelectDogView) {
                    SelectDogList(favoriteDog: $favorite,
                                  isPresented: $displaySelectDogView)
                }
                
                
                
            }
            //            .onAppear {
            //                self.favorite = favoriteDog
            //            }
            
            
            
            // Extras
            // Set secondary information
            Section(header: Text("Secondary") ) {
                
                // Notes feild
                TextField("Notes", text: $notes)
                    .padding()
                    
                    
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
                            .animation(displayExtraSettings ? .default : nil)
                        
                    }
                    
                })
                .foregroundColor(.primary)
                .padding()
                
                // Open Extra Parameters
                if displayExtraSettings == true {
                    
                    ToggleRow(icon: "pills",
                              color: .darkGreen,
                              title: "Treat",
                              isOn: $treat)
                        .padding()
                        .animation(.default)
                    
                    
                    ToggleRow(icon: "target",
                              color: .darkGreen,
                              title: "Correct Spot",
                              isOn: $correctSpot)
                        .padding()
                        .animation(.default)
                    
                }
                
            }
            
            
            Section {
                // Save button - TESTING - go to SwiftUIView
                Button("Save") {
                    /// Newly created BathroomEntry
                    guard let newEntry = bathroomBreak.createNewEntry() else { return }
                    /// convert treat into bool
                    //                    guard let treated = self.bathroomBreak.intToBool(self.treat) else { return }
                    /// convert brSpot to Int
                    //                    guard let spot = self.bathroomBreak.intToBool(self.correctSpot) else { return }
                    
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
                    
                    
                    /// Update & Save newly created BathroomEntry
                    self.bathroomBreak.update(entry: newEntry,
                                              correctSpot: correctSpot,
                                              notes: self.notes,
                                              date: Date(),
                                              treat: treat,
                                              type: selectedType )
                    
                    print("BathroomBreak Saved! - \(newEntry)")
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

        
    } // Body
} // BathroomEntryView

//struct BathroomEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        BathroomEntryView()
//    }
//}
