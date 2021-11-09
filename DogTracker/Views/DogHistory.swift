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
    
    
    
    let dog: Dog? = nil
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

    /// Bool to indicate weather or not to fetch the current week on appear of view
    @State private var fetchCurrentWeekOnAppear: Bool = false
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
                    elementesCount: $entriesCount) {
            DogHistoryFilter(type: $filterType)
            Text("Hello, World!")
        }
        
    }
}

@available(iOS 14.0, *)
struct DogHistory_Previews: PreviewProvider {
    static var previews: some View {
        DogHistory()
        HistoryList(firstDate: .constant(Date()),
                    lastDate: .constant(Date()),
                    currentWeek: .constant([]),
                    fetchCurrentWeekOnAppear: .constant(false),
                    elementesCount: .constant(1)) {
            Text("Hello World!")
        }
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

@available (iOS 14.0, *)
struct HistoryList<Content: View>: View {
    
    let dateControllerProvider = DateControllerProvider()
    let formatter = DateFormatter()
    
    @Binding var firstDate: Date
    @Binding var lastDate: Date
    /// Should be an emptpy array to contain what dates the provider will produce
    @Binding var currentWeek: [String]
    var size: DateController.DateControllerSize = .large
    @Binding var fetchCurrentWeekOnAppear: Bool
    @Binding var elementesCount: Int
    
    
    /// Background Colors
    @Environment(\.colorScheme) var colorScheme
    @State private var backgroundColor: Color = .backgroundGray
    
    
    // List to be passed in
    @ViewBuilder var content: Content
    
    var body: some View {
        ZStack {
            
            backgroundColor
                .ignoresSafeArea()
                .onAppear {
                    setBackgroundColorOnAppear()
                    
                    switch fetchCurrentWeekOnAppear {
                    case true:
                        break
                    case false:
                        currentWeek = dateControllerProvider.weekOf(the: firstDate)
                    }
                    
                }
                .onChange(of: colorScheme) { _ in
                    updateBackgroundColor()
                }

            
            
            
            VStack {
                dateController()
                List {
                    content
                        .padding()
                }
                
            }
            
            .navigationTitle( Text("Title") )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text(elementesCount != 0 ? "Entries for week: \(elementesCount)": "")
                }
                
            }
            
            
            
        }
    
    }
    
    
}

// Date Controller
@available (iOS 14.0, *)
extension HistoryList {
    
    /// Date Controller
    func dateController() -> some View {
        return DateController(firstDate: $firstDate,
                              lastDate: $lastDate,
                              size: size,
                              fetchCurrentWeekOnAppear: $fetchCurrentWeekOnAppear)
    }
    
}

// Background Color Handling
@available (iOS 14.0, *)
extension HistoryList {
    
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
