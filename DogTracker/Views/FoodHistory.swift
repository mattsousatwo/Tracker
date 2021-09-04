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

    let formatter = DateFormatter()
    
    var food: Food
    @ObservedObject var foodEntries = FoodEntries()
    @State private var entriesForFood: [FoodEntry] = []
    @State private var firstDate: Date = Date()
    @State private var lastDate: Date = Date()
    
    var body: some View {
        
        DateController(firstDate: $firstDate,
                       lastDate: $lastDate,
                       size: .large)
            .onAppear {
                if let entries = foodEntries.fetchAllEntries(for: food) {
                    entriesForFood = entries
                }
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
                    .animation(.default)
            }
            
        }
    }
    
}

@available(iOS 14.0, *)
extension FoodHistory {
    
    /// Zero Entries Text
    func zeroEntriesText() -> some View {
        Text("Entries for week: 0")
    }
    
    /// ForEach Entry load a row
    func entriesStack() -> some View {
        ForEach(entriesForFood, id: \.self) { entry in
            rowFor(entry: entry)
        }
    }
    
    /// Entry Row
    func rowFor(entry: FoodEntry) -> some View {
        let date = extractDate(from: entry)
        return NavigationLink {
            Text("Hello, World!")
        } label: {
            Text(date)
                .padding()
        }
    }
    
}


@available(iOS 14.0, *)
extension FoodHistory {
    
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
    
    
}

//struct FoodHistory_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodHistory()
//    }
//}
