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
    
    var bathroomTypes = ["Pee", "Poop", "Food", "Water", "Vomit"]
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
    
    
    
    // Body
    var body: some View {
        
        Form {
            // Main information
            Section(header: Text("Main") ) {
                Group {
                    
                    // Set entry type
                    Picker(selection: $type, label: Text("") , content: {
                        ForEach(0..<bathroomTypes.count) { index in
                            Text(self.bathroomTypes[index]).tag(index)
                                .padding()
                        }
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                }
                
                
                HStack {
                    Icon(image: "clock", color: .androidGreen)
                    
                    // Set Time for entry
                    DatePicker("Set Time", selection: $setTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .padding()
                }
                
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
                .foregroundColor(.black)
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
                    
                    /// Update & Save newly created BathroomEntry
                    self.bathroomBreak.update(entry: newEntry,
                                              correctSpot: correctSpot,
                                              notes: self.notes,
                                              date: Date(),
                                              treat: treat,
                                              type: Int16(self.type) )
                    
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
