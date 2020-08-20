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
    @State private var favoriteColor = 0
    var bathroomTypes = ["Pee", "Poop", "Vomit"]
    @State private var notes = ""
    @State private var displayExtraSettings = false
    @State private var setTime = Date()
    @State private var type = 0
    
    @State private var showPopover: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    Group {

                    
                        EntryRow(bindingType: $type, label: "log type", segmentArray: ["Food", "Bathroom", "Vet"])
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
//                            EntryRow(label: "bathroomType", segmentArray: bathroomTypes)
//                    
//                            EntryRow(label: "Gave Treat", segmentArray: ["yes", "no"])
//                    
//                            EntryRow(label: "Correct Spot", segmentArray: ["yes", "no"] )
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
                    self.showPopover = true
                } .sheet(isPresented: $showPopover) {
                    SwiftUIView()
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
        .onAppear( perform: {
            self.x.fetch()
            if self.x.bathroomEntries != nil {
                guard let first = self.x.bathroomEntries?.first else { return }
                
                self.type = Int(first.type)
                self.notes = first.uid!
            }
        })
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    
    }
}
