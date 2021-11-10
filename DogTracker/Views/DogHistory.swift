//
//  DogHistory.swift
//  DogTracker
//
//  Created by Matthew Sousa on 11/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct DogHistory: View {
    
    
    
    var dog: Dog? = nil
    var food: Food? = nil
    let formatter = DateFormatter()
    
    @ObservedObject var foodStore = FoodEntries()
    @ObservedObject var bathroomStore = BathroomBreak()
    
    /// date controller model
    let dateControllerProvider = DateControllerProvider()
    @State private var foodEntries: [FoodEntry] = []
    @State private var bathroomEntries: [BathroomEntry] = []
    @State private var entriesCount: Int = 0
    
    @State private var firstDate: Date = Date()
    @State private var lastDate: Date = Date()
    @State private var currentWeek: [String] = []
    @State private var title: String = ""
    
    /// Bool to indicate weather or not to fetch the current week on appear of view
    @State private var fetchCurrentWeekOnAppear: Bool = true
    /// Bool to indicate when element detail did dismiss
    @State private var elementDetailDidDismiss: Bool = false
    
    /// Background Color
    @State private var backgroundColor: Color = .backgroundGray
    @Environment(\.colorScheme) var colorScheme
    
    /// Filter List types
    @State private var filterType: EntryType = .pee
    
    var body: some View {
        
        // Filter button
        // Entry count
        // Name of mode
        // DatePicker
        // Entry List
        
        
        
        HistoryList(firstDate: $firstDate,
                    lastDate: $lastDate,
                    currentWeek: $currentWeek,
                    fetchCurrentWeekOnAppear: $fetchCurrentWeekOnAppear,
                    elementesCount: $entriesCount,
                    title: $title) {
            
            
            DogHistoryFilter(type: $filterType)
            Text("Hello, World!")
            
            
        }
                    .onAppear {
                        if let name = dog?.name {
                            title = name
                        }
                    }
        
    }
}

@available(iOS 14.0, *)
struct DogHistory_Previews: PreviewProvider {
    static var previews: some View {
        DogHistory()
    }
}





/// Can Delete - Used in HistoryView (can delete as well)
struct HistoryElement: Hashable {
    
    let name: String
    var entries: [BathroomEntry]
    var id = UUID().uuidString
    
    init(name: String, entries: [BathroomEntry]) {
        self.name = name
        self.entries = entries
    }
}

