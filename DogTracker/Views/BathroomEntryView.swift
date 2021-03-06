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
    
    // Time
    @State private var setTime = Date()
    // Bathroom Type
    @State private var type = 0
    // Correct Spot
    @State private var correctSpot = 0
    // Notes
    @State private var notes = ""
    // Treat Given
    @State private var treat = 0
    // Photo
    
    
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
            
            
            
            // Extras
            // Set secondary information
            Section(header: Text("Secondary") ) {
                
                // Notes feild
                TextField("Notes", text: $notes)
                    .padding()

                Button(action: {
                    self.displayExtraSettings.toggle()
                }, label: {
                    Text("Extras").font(.subheadline).foregroundColor(.blue)
                })
                .padding()
                
                // Open Extra Parameters
                if displayExtraSettings == true {
                    
                    // If Gave treat
                    BoolSegmentRow(bindingType: $treat, label: "Treat", option1: "Yes", option2: "No")
                        .padding()
                        .animation(.default)
                    // If in correct spot
                    BoolSegmentRow(bindingType: $correctSpot, label: "Correct Spot", option1: "Yes", option2: "No")
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
                    guard let treated = self.bathroomBreak.intToBool(self.treat) else { return }
                    /// convert brSpot to Int
                    guard let spot = self.bathroomBreak.intToBool(self.correctSpot) else { return }
                    
                    /// Convert Date into Time
                    let formatter = DateFormatter()
                    let time = formatter.timeFormat(Date() )
                    let date = formatter.dateFormat(Date() )
                    
                    
                    /// Update & Save newly created BathroomEntry
                    self.bathroomBreak.update(entry: newEntry,
                                              correctSpot: spot,
                                              notes: self.notes,
                                              date: date,
                                              time: time,
                                              treat: treated,
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

struct BathroomEntryView_Previews: PreviewProvider {
    static var previews: some View {
        BathroomEntryView()
    }
}
