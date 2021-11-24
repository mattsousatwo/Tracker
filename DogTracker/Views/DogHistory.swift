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
    @State var filterElements: [EntryType] = []
    
    
    @State private var viewState: HistoryListState = .initialize
    
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
            case .successfulLoad:
                successfulLoadState()
            case .noResultsFound:
                noResultsState()
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
                        loadEntries()
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
        
//        DogHistory(viewState: .initialize)
        HistoryListElement("My Text")
        
        
        
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
                loadEntries()
            }
    }
    
    func loadEntries() {
        viewState = .loading(type: filterElements)
        let elements = fetchHistoryListElements()
        switch historyListElements.count {
        case 0:
            viewState = .noResultsFound
        default:
            historyListElements = elements
            viewState = .successfulLoad
            
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
                        elements = getFoodEntriesForWeek(of: [element], for: dog)
                    }
                }
            default:  // Return All Entries (Food + Bathroom)
                elements = getBathroomEntriesForWeek(of: [.pee, .poop, .vomit],
                                                     for: dog)
                elements.append(contentsOf: getFoodEntriesForWeek(of: [.food, .water],
                                                                  for: dog) )
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
            if entries.count != 0 {
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
        var elements: [HistoryListElement] = []
        guard isFoodType(type) == true else { return elements }
        for type in type {
            if let entries = foodStore.getEntries(in: currentWeek,
                                                  for: dog,
                                                  ofType: type) {
                if entries.count != 0 {
                    for entry in entries {
                        elements.append(HistoryListElement(entry) )
                    }
                }
            }
        }
        viewState = .successfulLoad
        
        
        return elements
    }
    
    // Load values from the successful load
    func successfulLoadState() -> some View  {
        print("Load Elements from fetch")
        return ForEach(historyListElements) { element in
            element
                .padding()
        }.onDelete { index in
            deleteEntry(at: index)
        }
    }
    
    // Display no results entry
    func noResultsState() -> some View {
        return Text("Entries for week: 0")
                .padding()
    }
    
    // Delete Bathroom Entry or Food Entry at index
    func deleteEntry(at set: IndexSet) {
        guard let index = set.first else { return }
        let selectedElement = historyListElements[index]
        historyListElements.remove(at: index)
        
        
        let id = selectedElement.unwrap(value: .uuid)
        
        let entryType = selectedElement.unwrapType()
        if isFoodType([entryType]) == true {
            // Food
            foodStore.deleteSpecificElement(.foodEntry, id: id)
        } else {
            // Bathroom
            bathroomStore.deleteSpecificElement(.bathroomBreak, id: id)
        }
    }
    
    func entryType(from typeString: String) -> EntryType? {
        switch typeString {
        case EntryType.pee.rawValue:
            return EntryType.pee
        case EntryType.poop.rawValue:
            return EntryType.poop
        case EntryType.vomit.rawValue:
            return EntryType.vomit
        case EntryType.food.rawValue:
            return EntryType.food
        case EntryType.water.rawValue:
            return EntryType.water
        default:
            return nil
        }
    }
    
}

struct HistoryListElement: View, Identifiable, Equatable  {
    
    let formatter = DateFormatter()
    
    var id: String {
        return UUID().uuidString
    }
    
    
    var foodEntry: FoodEntry? = nil
    var bathroomEntry: BathroomEntry? = nil
    var defaultText: String = "default text"
    
    init(_ foodEntry: FoodEntry) {
        self.foodEntry = foodEntry
    }
    
    init(_ bathroomEntry: BathroomEntry) {
        self.bathroomEntry = bathroomEntry
    }
    
    init(_ text: String) {
        self.defaultText = text
    }
    
    
    
    
    
    var body: some View {
        
        HStack {
            tag()
            date()
        }
        
    }
    
    
    func date() -> some View {
        let date = format(date: unwrap(value: .date))
        return Text(date)
    }
    
    func tag() -> some View {
        return Text(unwrap(value: .tag) )
    }
    
    
    // Get value from history element type
    func unwrap(value: EntityValue) -> String {
        var textValue: String = ""
        
        if let foodEntry = foodEntry {
            switch value {
            case .tag, .type:
                textValue = "\(unwrapType().rawValue)"
            case .uuid:
                textValue = foodEntry.uuid ?? ""
            case .measurment:
                textValue = foodEntry.measurement ?? ""
            case .date:
                textValue = foodEntry.date ?? ""
            case .notes:
                textValue = foodEntry.notes ?? ""
            case .dogID:
                textValue = foodEntry.dogID ?? ""
                
            // Batrhoom
            case .correctSpot, .time, .treat:
                break
            }
            
        }
        if let bathroomEntry = bathroomEntry {
            switch value {
            case .tag, .type:
                textValue = "\(unwrapType().rawValue)"
            case .uuid:
                textValue = bathroomEntry.uid ?? ""
            case .date:
                textValue = bathroomEntry.date ?? ""
            case .notes:
                textValue = bathroomEntry.notes ?? ""
            case .dogID:
                textValue = bathroomEntry.dogUUID
            case .correctSpot:
                textValue = "\(bathroomEntry.correctSpot)"
            case .time:
                textValue = bathroomEntry.time ?? ""
            case .treat:
                textValue = "\(bathroomEntry.treat)"
                
            // Food
            case .measurment:
                break
            }

        }
        
        return textValue
    }

    func format(date: String) -> String {
        if let date = formatter.convertStringToDate(date) {
            let convertedDate = formatter.foodHistoryFormat(date)
            return convertedDate
        }
        return ""
    }
    
    // Unwrap the EntryType Value from the entry
    func unwrapType() -> EntryType {
        var type: EntryType = .pee
        if let foodEntry = foodEntry {
            switch foodEntry.type {
            case 0, 1, 2:
                break
            case 3:
                type = .food
            case 4:
                type = .water
            default:
                type = .food
            }
        } else if let bathroomEntry = bathroomEntry {
            switch bathroomEntry.type {
            case 0:
                type = .pee
            case 1:
                type = .poop
            case 2:
                type = .vomit
                
            case 3, 4:
                break
            default:
                type = .pee
            }
        }
        return type
    }
    
    
}


enum EntityValue {
    // Food
    case uuid
    case measurment
    case date
    case notes
    case dogID
    case type
    
    // Bathroom
    case correctSpot
//    case notes
//    case photo
    case time // String
    case treat
//    case type
//    case uuid
//    case dogID
//    case date
    
    case tag
    
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

