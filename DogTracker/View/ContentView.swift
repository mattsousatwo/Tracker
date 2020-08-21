//
//  ContentView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/10/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let x = BathroomBreak()
    
    var bathroomTypes = ["Pee", "Poop", "Vomit"]
    // Display; Gave Treat, Correct Spot, Photo Option,
    @State private var displayExtraSettings = false
    
    // Log Type
    @State private var logType = 0
    
    // Time
    @State private var setTime = Date()
    // Bathroom Type
    @State private var type = 0 
    // Correct Spot
    @State private var correctSpot = true
    // Notes
    @State private var notes = ""
    // Treat Given
    @State private var treat = false
    // Photo
    

    
    
    @State private var showPopover: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    Group {

                    
                        EntryRow(bindingType: $logType, label: "log type", segmentArray: ["Food", "Bathroom", "Vet"])
                        Picker("Title", selection: $type, content: {
                            ForEach(0..<bathroomTypes.count) { index in
                                Text(self.bathroomTypes[index]).tag(index)
                                    .padding()
                            }
                        })
                            .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    
                    DatePicker("Set Time", selection: $setTime, displayedComponents: .hourAndMinute)
                        .padding()
                
                }
                
                
    
                
                Section {
                    TextField("Notes", text: $notes)
                                                
                }
                
                Section {
                    VStack {
                        Button("Extras") {
                            self.displayExtraSettings.toggle()
                            }
                        
                    }
                    
                        if displayExtraSettings == true {
                            EntryRow(bindingType: $type, label: "bathroomType", segmentArray: bathroomTypes)
//                    
//                            EntryRow(label: "Gave Treat", segmentArray: ["yes", "no"])
//                    
//                            EntryRow(bindingType: $correctSpot, label: "Correct Spot", segmentArray: ["yes", "no"] )
//                            
                            Button("Hide") {
                                self.displayExtraSettings.toggle()
                            }
                                .font(.caption)
                        }
                    
                    Text("\(self.type)")
                }
                
     
                
                // Save button - TESTING - go to SwiftUIView
                Button("save") {
                    if self.x.bathroomEntries != nil {
//                        guard let first = self.x.bathroomEntries?.first else { return }
                        guard let first = self.x.bathroomEntries?.first(where: { $0.uid == self.x.selectedUID }) else { return }
                        self.x.update(entry: first.uid!, correctSpot: self.correctSpot, notes: self.notes, time: self.setTime, treat: self.treat, type: self.type)
                    }
                    
                }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 20))
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .navigationBarTitle(Text("Enter Information"))
        
        }
        
        // View did load ()
        .onAppear( perform: {
            
            self.x.createAndReturn()
            
            self.x.fetch()
            if self.x.bathroomEntries != nil {
                
                guard let first = self.x.bathroomEntries?.first(where: { $0.uid == self.x.selectedUID }) else { return }
                
                self.correctSpot = first.correctSpot
                self.notes = first.uid!
                self.setTime = first.time!
                self.treat = first.treat 
                self.type = Int(first.type)
            }
        })
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    
    }
}
