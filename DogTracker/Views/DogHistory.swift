//
//  DogHistory.swift
//  DogTracker
//
//  Created by Matthew Sousa on 11/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI
import Alamofire

@available(iOS 15.0, *)
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
    @State private var historyListElements: [HistoryListElement] = []
    @State private var entriesCount: Int = 0
    
    /// Date Properties
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
    @State var filterElements: [EntryType] = [.pee]
    
    
    @State var viewState: HistoryListState = .initialize
    
    var body: some View {
        
        HistoryList(firstDate: $firstDate,
                    lastDate: $lastDate,
                    currentWeek: $currentWeek,
                    fetchCurrentWeekOnAppear: $fetchCurrentWeekOnAppear,
                    elementesCount: $entriesCount,
                    title: $title,
                    filterElements: $filterElements) {
            
            switch viewState {
            case .initialize:
                
                
                initializeState()
                
            case .loading:
                loadingState()
                
                if historyListElements.count > 0 {
                    
                    ForEach(historyListElements) { element in
                        element
                    }
                    
                    
                }
            case .successfulLoad:
                successfulLoadState()
            case .noResultsFound:
                Text(viewState.value)
            case .APIError:
                Text(viewState.value)
            }
            
            
        }
                    .onChange(of: filterElements) { newFilterElements in
                        viewState = .loading(type: newFilterElements)
                    }
                    .onAppear {
                        if let name = dog?.name {
                            title = name
                        }
                    }
                    .onChange(of: viewState) { newValue in
                        
                        switch viewState {
                        case .initialize:
                            break
                        case .loading( _):
                            historyListElements = fetchHistoryListElements()
                            
                        case .successfulLoad:
                            break
                        case .noResultsFound:
                            break
                        case .APIError:
                            break
                        }
                        
                        print("viewState change -> \(newValue.value)")
                    }
                    .onChange(of: historyListElements) { newValue in
                        entriesCount = historyListElements.count
                        if newValue.count > 0 {
                            viewState = .successfulLoad
                        }
                    }
                    .onChange(of: firstDate) { newValue in
                        historyListElements = []
                        currentWeek = dateControllerProvider.weekOf(the: firstDate)
                        viewState = .loading(type: filterElements)
                    }
                    
                    
        
    }
}

@available(iOS 15.0, *)
struct DogHistory_Previews: PreviewProvider {
    static var previews: some View {
        DogHistory(viewState: .initialize)
    }
}


@available(iOS 15.0, *)
extension DogHistory {
    
    func initializeState() -> some View {
        Text(viewState.value)
            .onAppear {
                
                if filterElements.count > 0 {
                    viewState = .loading(type: filterElements)
                } else {
                    viewState = .noResultsFound
                }
                
            }

    }
    
    func loadingState() -> some View {
        return Text("Loading")
            .onAppear {
                historyListElements = fetchHistoryListElements()
            }
    }
    
    /// Fetch elements for list
    func fetchHistoryListElements() -> [HistoryListElement] {
        var elements: [HistoryListElement] = []
        if let dog = dog  {
            
            
            switch Double(filterElements.count) { // Return Selected Types
                
            case 1...Double.infinity: // Return Selected Types
                for element in filterElements {
                    switch element {
                        // Bathroom Entries
                    case .pee, .poop, .vomit:
                        elements = getBathroomEntriesForWeek(of: [element], for: dog)
                        
                        // Food Entries
                    case .food, .water:
                        print("Load \(element.rawValue)")
                    }
                    
                    
                }
            default:  // Return All Entries (Food + Bathroom)
                
                print("Load all types")
            }
            
            
        }
        return elements
    }
    
    /// Fetch and convert Bathroom Entries
    func getBathroomEntriesForWeek(of type: [EntryType], for dog: Dog) -> [HistoryListElement] {
        var elements: [HistoryListElement] = []
        guard isTypeBathroomType(type) == true else { return elements }
        if let entries = bathroomStore.getEntriesForWeek(currentWeek,
                                                         for: dog,
                                                         type: type) {
            if entries.count == 0 {
                viewState = .noResultsFound
            } else {
                for entry in entries {
                    elements.append(HistoryListElement(entry) )
                }
                viewState = .successfulLoad
            }
        }
        
        return elements
    }
    // Detect if Entry type is of .food or .water
    func isFoodType(_ type: [EntryType]) -> Bool {
        if type == [.food] || type == [.water] || type == [.food, .water] {
            return true
        }
        return false
    }
    
    // Detect if Entry type is of .pee, .poop, or .vomit
    func isTypeBathroomType(_ type: [EntryType]) -> Bool {
        if isFoodType(type) == false {
            return true
        }
        return false
    }
    
    /// Fetch and convert Food Entries
    func getFoodEntriesForWeek(of type: [EntryType], for dog: Dog) -> [HistoryListElement] {
        let elements: [HistoryListElement] = []
        guard isFoodType(type) == true else { return elements }
        return elements
    }
    
    func successfulLoadState() -> some View  {
        return ForEach(historyListElements) { element in
            element
        }
    }
    
    func noResultsState() {
        
    }
    
}

struct HistoryListElement: View, Identifiable, Equatable  {
    
    var id: String {
        return UUID().uuidString
    }
    
    
    var foodEntry: FoodEntry? = nil
    var bathroomEntry: BathroomEntry? = nil
    
    init(_ foodEntry: FoodEntry) {
        self.foodEntry = foodEntry
    }
    
    init(_ bathroomEntry: BathroomEntry) {
        self.bathroomEntry = bathroomEntry
    }
    
    
    var body: some View {
        if let foodEntry = foodEntry {
            Text("History List Element: \(foodEntry.date ?? "")")
        }
        else if let bathroomEntry = bathroomEntry {
            Text("History List Element: \(bathroomEntry.date ?? "")")
        }
        
    }
    
}




enum HistoryListState: Equatable {
    
    case initialize
    case loading(type: [EntryType])
    case successfulLoad
    case noResultsFound
    case APIError
    
    var value: String {
        switch self {
        case .initialize:
            return "init"
        case .loading(let type):
            return "Loading: \(type)"
        case .successfulLoad:
            return "Successful"
        case .noResultsFound:
            return "No Results Found"
        case .APIError:
            return "API Error"
        }
    }
    
    
    func loadingValues() -> [EntryType]? {
        switch self {
        case .loading(let type):
            return type
        default:
            return nil
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

