//
//  FilterView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 11/10/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

@available(iOS 15.0, *)
struct FilterView: View {
    
    @ObservedObject var foods = Foods()
    @State var allFoods: [Food] = []
    
    @Binding var filterList: Set<FilterListElement>
    

    var body: some View {
        
        // list of entry types
        List {
            
            entryTypeList()
            
            if displayFoodList() == true {
                savedFoodsList()
            }
        
            
        }
        .onAppear {
            onAppear()
        }
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                if filterList.count > 0 {
                    Button {
                        filterList.removeAll()
                    } label: {
                        Text("Clear")
                    }
                }

                
            }
            
        }
        .navigationTitle(Text("Filter History") )
        
    }
    
    /// Add or remove entryType to filter list
    func appendToFilterList(_ element: FilterListElement) {
        switch filterList.contains(element) {
        case true:
            filterList.remove(element)
        case false:
            filterList.insert(element)
        }
    }
    
    /// List to choose an entry type - Pee, Poop, Vomit, Food, Water
    func entryTypeList() -> some View {
        Section("Type") {
            ForEach(EntryType.allCases) { type in
                let element = FilterListElement(type)
                
                Button {
                    appendToFilterList(element)
                } label: {
                    HStack {
                        Text(type.rawValue)
                            .foregroundColor(filterList.contains(element) ? .lightBlue: .primary)
                        Spacer()
                    }
                    .padding()
                }
            }
        }
    }
    
    // List of foods to select from
    func savedFoodsList() -> some View {
        Section("Select Food") {
            ForEach(allFoods, id: \.self) { food in
                Button {
                    let element = FilterListElement(food)
                    appendToFilterList(element)
                } label: {
                    HStack {
                        if let name = food.name {
                            Text(name)
                                .foregroundColor(filterList.contains(FilterListElement(food)) ? .lightBlue: .primary)
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
        }
    }
    
    // Methods to run on appear
    func onAppear() {
        // Load food entries
        allFoods = foods.getAllFoods()
    }
    
    // Check if food selection should be displayed
    func displayFoodList() -> Bool {
        let filterElement = FilterListElement(EntryType.food)
        if filterList.contains(filterElement) == true ||
            filterList.count == 0 {
            
            if allFoods.count != 0 {
                return true
            }
        }
        return false
    }
    
}

//@available(iOS 15.0, *)
//struct FilterView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterView(filterList: .constant([]) )
//    }
//}


struct FilterRow: View {
    
    let title: EntryType
    
    @State private var isChosen: Bool = false
    
    var body: some View {
        
        Button {
            self.isChosen.toggle()
        } label: {
            HStack {
                Text(title.rawValue)
                    .foregroundColor(isChosen ? .lightBlue: .primary)
                Spacer()
            }
            .padding()
        }
    }
}


protocol FilterListIdentifiable: Hashable {
    var id: String { get }
}

extension FilterListIdentifiable{
    var id: String {
        get {
            return UUID().uuidString
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}


class FilterListElement {
    var food: Food? = nil
    var entryType: EntryType? = nil
    
    init(_ food: Food) {
        self.food = food
    }
    init(_ entryType: EntryType) {
        self.entryType = entryType
    }
        
}


extension FilterListElement: Hashable {
    
    static func == (lhs: FilterListElement, rhs: FilterListElement) -> Bool {
        if let leftFood = lhs.food, let rightFood = rhs.food {
            return leftFood.uuid == rightFood.uuid
        } else if let leftEntry = lhs.entryType, let rightEntry = rhs.entryType {
            return leftEntry.asInt == rightEntry.asInt
        }
        return false
    }
    
    func hash(into hasher: inout Hasher) {
        
        if let food = food {
            hasher.combine(food.uuid)
        } else if let entry = entryType {
            hasher.combine(entry.asInt)
        }

        
        
        
        
        
    }
    
}
