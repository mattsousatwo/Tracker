//
//  DogHistory.swift
//  DogTracker
//
//  Created by Matthew Sousa on 11/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct DogHistory: View {
    
    let dog: Dog
    var food: Food? = nil
    let formatter = DateFormatter()
    
    @ObservedObject var foodStore = FoodEntries()
    @ObservedObject var bathroomStore = BathroomBreak()
    
    /// date controller model
    let dateControllerProvider = DateControllerProvider()
    @State private var foodEntries: [FoodEntry] = []
    @State private var bathroomEntries: [BathroomEntry] = []
    @State private var firstDate: Date = Date()
    @State private var lastDate: Date = Date()
    @State private var currentWeek: [String] = []

    /// Bool to indicate weather or not to fetch the current week on appear of view
    @State private var fetchCurrentWeekOnAppear: Bool = true
    /// Bool to indicate when element detail did dismiss
    @State private var elementDetailDidDismiss: Bool = false
    
    var body: some View {
        
        // Filter button
        // Entry count
        // Name of mode
        // DatePicker
        // Entry List
        
        
        Text("Hello, World!")
        
    }
}

struct DogHistory_Previews: PreviewProvider {
    static var previews: some View {
        DogHistory(dog: Dog() )
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

