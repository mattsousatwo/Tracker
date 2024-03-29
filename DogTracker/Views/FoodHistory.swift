//
//  FoodHistory.swift
//  FoodHistory
//
//  Created by Matthew Sousa on 8/31/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

@available(iOS 15.0, *)
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
    @State private var elementsCount: Int = 0
    
    @State private var fetchCurrentWeekOnAppear: Bool = true
    @State private var foodDetailDidDismiss: Bool = false
    
    @State private var foodName: String = ""
    
    var body: some View {
        
        foodHistoryBody()
        
    }
    
}

@available(iOS 15.0, *)
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


@available(iOS 15.0, *)
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
    
    /// Food History body
    func foodHistoryBody() -> some View {
        return HistoryList(firstDate: $firstDate,
                           lastDate: $lastDate,
                           currentWeek: $currentWeek,
                           fetchCurrentWeekOnAppear: $fetchCurrentWeekOnAppear,
                           elementesCount:  $elementsCount,
                           title: $foodName,
                           displayFilterButton: false,
                           filterElements: .constant([])) {
            switch entriesForFood.count {
            case 0:
                zeroEntriesText()
            default:
                entriesStack()
            }
            
        }
                           .onAppear {
                               guard let name = food.name else { return }
                               foodName = name
                           }
        
                            /// When current week changes fetch all entries for this week
                           .onChange(of: currentWeek) { _ in
                               let entries = foodEntries.getAllEntries(for: food,
                                                                          in: currentWeek )
                               entriesForFood = entries
                               elementsCount = entriesForFood.count
                           }
                            
                            /// When the first date is changed update the current week to the new weeks dates
                           .onChange(of: firstDate) { newValue in
                               currentWeek = dateControllerProvider.weekOf(the: newValue)
                           }
                            
                            /// Change background color when color scheme changes
                           .onChange(of: colorScheme) { _ in
                               updateBackgroundColor()
                           }
                            
                           /// When the user returns from looking at the food entry detail keep the date controller at the current date
                           .onChange(of: foodDetailDidDismiss) { newValue in
                               if foodDetailDidDismiss == true {
                                   fetchCurrentWeekOnAppear = false
                                   foodDetailDidDismiss = false
                               }
                           }
        
   
                
        
        
        
    }
    
}

//struct FoodHistory_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodHistory()
//    }
//}
