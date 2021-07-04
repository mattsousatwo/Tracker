//
//  HistoryView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 7/1/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    let conversion = Conversion()
    @ObservedObject var bathroomBreak = BathroomBreak()
    @ObservedObject var foodEntries = FoodEntries()
    @ObservedObject var dogs = Dogs()
    
    @State var isOn: Bool = true
    
    
    @State private var historyElements: [HistoryElement] = []
    
    
    var body: some View {

        Form {
            
            Section(header:
                HStack {
                    Text(isOn ? "Bathroom Use" : "Food Consumption")
                    Spacer()
                    if #available(iOS 14.0, *) {
                        Toggle(isOn: $isOn) {
                            Text("")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .padding(.bottom, 5)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            ) {
                
                
                switch isOn {
                case true:
                    
                    ForEach(historyElements, id: \.self) { entry in
                        if entry.entries.count != 0 {
                            section(entry)
                        }
                    }
                    
                    
                case false:
                    
                    
                    if let entries = foodEntries.entries {
                        if entries.count >= 1 {
                            
                            ForEach(entries, id: \.self) { entry in
                                if let date = entry.date {
                                    
                                    if let date = conversion.convertDate(date), let convertedDate = conversion.formatDateToNormalStyle(date) {
                                        Text(convertedDate)
                                            .padding()
                                    }
                                }
                            }
                        } else {
                            Text("There are 0 food entries")
                        }
                        
                        
                        
                    }
                    
                    
                }

                
                
                
                
                
                
                
                
            }
        }
        
        .onAppear {
            historyElements = getAllBathroomEntriesByDog()
            if isOn == true {
                bathroomBreak.fetchAll()
            } else {
                foodEntries.fetchAll()
            }
            print("Bathroom Use count \(bathroomBreak.bathroomEntries?.count)")
        }
        .navigationBarTitle(Text("History"))
    
    }
    
    func section(_ entry: HistoryElement) -> some View {
        return
            VStack(alignment: .leading) {
                if entry.entries.count != 0 {
                    Text(entry.name)
                        .fontWeight(.bold)
                        .padding(.vertical)
                    Divider()
                    ForEach(0..<entry.entries.count, id: \.self) { i in
                        if let date = conversion.historyRowFormat(entry.entries[i].date) {
                            VStack(alignment: .leading) {
                                Text(date)
                                    .padding(.vertical)
                                if i != entry.entries.count - 1 {
                                    Divider()
                                }
                            }
                        }
                        
                    }
                    
                }
                
            }
        
    }
    
    func getAllBathroomEntriesByDog() -> [HistoryElement] {
        if bathroomBreak.bathroomEntries?.count == 0 {
            bathroomBreak.fetchAll()
        }
        if dogs.allDogs.count == 0 {
            dogs.fetchAll()
        }
        
        var entries = [BathroomEntry]()
        var elements = [HistoryElement]()
        
        for dog in dogs.allDogs {
            
//            if let bathroomEntries = bathroomBreak.bathroomEntries {
//                for bathroomEntry in bathroomEntries {
//                    if bathroomEntry.dogUUID == dog.uuid {
//                        entries.append(bathroomEntry)
//                    }
//                }
//            }
            if let dogsEntries = bathroomBreak.fetchAllEntries(for: dog.uuid) {
                entries = dogsEntries.sorted(by: { (entryOne, entryTwo) in
                    guard let dateOne = entryOne.date, let dateTwo = entryTwo.date else { return false }
                    return dateOne < dateTwo
                    
                })
            }
            
            if let name = dog.name {
                elements.append(HistoryElement(name: name, entries: entries))
            }
        }
        
        return elements
    }
    
 
    
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}


struct HistoryElement: Hashable {
    
    let name: String
    var entries: [BathroomEntry]
    var id = UUID().uuidString
    
    init(name: String, entries: [BathroomEntry]) {
        self.name = name
        self.entries = entries
    }
}
