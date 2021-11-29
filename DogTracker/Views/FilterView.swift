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
                    
                    if type == .food {
                        updateFoodList()
                    } else {
                        appendToFilterList(element)
                    }
                    
                    
                    
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
                    appendFoodToFilterList(food)
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
    
    func appendFoodToFilterList(_ food: Food) {
        let element = FilterListElement(food)
        appendToFilterList(element)
        if filterList.contains(FilterListElement(EntryType.food)) == false {
            filterList.insert(FilterListElement(EntryType.food))
        }
    }
    
    /// When EntryType.food is selected - select the favoriteFood
    func updateFoodList() {
        if allFoods.isEmpty == false {
            let foodType = FilterListElement(EntryType.food)
            switch filterList.contains(foodType ) {
                case true:
                    filterList.remove(foodType)
                    clearAllFoods()
                case false:
                    filterList.insert(foodType)
                    appendFavoriteFoodToFilterList()
                
                
            }
            
            
            
        }
    }
    
    func appendFavoriteFoodToFilterList() {
        if allFoods.isEmpty == false {
            for food in allFoods {
                if food.favorite() == true {
                    if filterList.contains(FilterListElement(food)) == false {
                        filterList.insert(FilterListElement(food) )
                    }
                }
            }
        }
    }
    
    /// Remove all Food from FilterList
    func clearAllFoods() {
        for element in filterList {
            if element.food != nil {
                filterList.remove(element)
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
        
        for element in filterList {
            if element.food != nil {
                return true
            }
        }
        if allFoods.count != 0 {
            if filterList.contains(filterElement) == true ||
                filterList.count == 0 {
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
    
    let title: String
    let action: () -> Void
    @State private var isChosen: Bool = false
    

    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        
        Button {
            self.isChosen.toggle()
            action()
        } label: {
            HStack {
                Text(title)
                    .foregroundColor(isChosen ? .lightBlue: .primary)
                Spacer()
            }
            .padding()
        }
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
