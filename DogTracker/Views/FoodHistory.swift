//
//  FoodHistory.swift
//  FoodHistory
//
//  Created by Matthew Sousa on 8/31/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct FoodHistory: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var backgroundColor: Color = .backgroundGray
    
    let dateControllerProvider = DateControllerProvider()
    
    let formatter = DateFormatter()
    
    var food: Food
    @ObservedObject var foodEntries = FoodEntries()
    @State private var entriesForFood: [FoodEntry] = []
    @State private var firstDate: Date = Date()
    @State private var lastDate: Date = Date()
    @State private var currentWeek: [String] = []
    
    @State private var fetchCurrentWeekOnAppear: Bool = true
    @State private var foodDetailDidDismiss: Bool = false
    
    var body: some View {
        
        ZStack {
            backgroundColor
                .ignoresSafeArea()
                .onAppear {
                    setBackgroundColorOnAppear()
                    
                    switch foodDetailDidDismiss {
                    case true:
                        fetchCurrentWeekOnAppear = false
                    case false:
                        fetchCurrentWeekOnAppear = true
                    }
                    
                    switch fetchCurrentWeekOnAppear {
                    case true:
                        break
                    case false:
                        currentWeek = dateControllerProvider.weekOf(the: firstDate)
                    }
                    
                }
            
            
            
            VStack {
                
                    DateController(firstDate: $firstDate,
                                   lastDate: $lastDate,
                                   size: .large,
                                   fetchCurrentWeekOnAppear: $fetchCurrentWeekOnAppear)
                
                    .onChange(of: currentWeek) { _ in
                        let entries = foodEntries.getAllEntries(for: food,
                                                                   in: currentWeek )
                        entriesForFood = entries
                    }
                    .onChange(of: firstDate) { newValue in
                        currentWeek = dateControllerProvider.weekOf(the: newValue)
                    }
                    .onChange(of: colorScheme) { _ in
                        updateBackgroundColor()
                    }
                
                
                List {
                    switch entriesForFood.count {
                    case 0:
                        zeroEntriesText()
                    default:
                        entriesStack()
                    }
                }
                
                .navigationTitle(Text(food.name ?? "nil"))
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Text(entriesForFood.count != 0 ? "Entries for week: \(entriesForFood.count)": "")
                        //                    .animation(.default)
                    }
                    
                }
                
            }
        }
        
        
        
        
        
    }
    
}

@available(iOS 14.0, *)
extension FoodHistory {
    
    /// Zero Entries Text
    func zeroEntriesText() -> some View {
        Text("Entries for week: 0")
            .padding()
    }
    
    /// ForEach Entry load a row
    func entriesStack() -> some View {
        ForEach(entriesForFood, id: \.self) { entry in
            rowFor(entry: entry)
        }.onDelete { index in
            deleteEntry(at: index)
        }
    }
    
    /// Entry Row
    func rowFor(entry: FoodEntry) -> some View {
        let date = extractDate(from: entry)
        return NavigationLink {
            FoodEntryDetail(entry: entry,
                            entries: $entriesForFood,
                            didDismiss: $foodDetailDidDismiss)
            
        } label: {
            Text(date)
                .padding()
        }
    }
    
}


@available(iOS 14.0, *)
extension FoodHistory {
    
    /// Delete row in stack
    func deleteEntry(at set: IndexSet) {
        guard let index = set.first else { return }
        guard let entryID = entriesForFood[index].uuid else { return }
        entriesForFood.removeAll(where: { $0.uuid == entryID })
        foodEntries.deleteSpecificElement(.foodEntry,
                                          id: entryID)
    }
    
    /// Get date from FoodEntry
    func extractDate(from entry: FoodEntry) -> String {
        if let date = entry.date {
            if let convertedDate = formatter.convertStringToDate(date) {
                let formattedDate = formatter.foodHistoryFormat(convertedDate)
                return formattedDate
                    
            }
        }
        return "nil"
    }
    
    /// Change background color on appear of view
    func setBackgroundColorOnAppear() {
        switch colorScheme {
        case .light:
            backgroundColor = .backgroundGray
        case .dark:
            backgroundColor = .black
        default:
            backgroundColor = .backgroundGray
        }
    }
    
    /// Change background color when color scheme changes
    func updateBackgroundColor() {
        switch colorScheme {
        case .light:
            backgroundColor = .black
        case .dark:
            backgroundColor = .backgroundGray
        default:
            backgroundColor = .backgroundGray
        }
    }
    
}

//struct FoodHistory_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodHistory()
//    }
//}
