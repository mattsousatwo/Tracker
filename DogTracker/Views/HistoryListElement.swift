//
//  HistoryListElement.swift
//  DogTracker
//
//  Created by Matthew Sousa on 12/2/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

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
    
    var isFoodType: Bool {
        if foodEntry != nil {
            return true
        }
        return false
    }
    
    var body: some View {
        
        switch isFoodType {
        case true:
            foodEntryBody()
        case false:
            bathroomEntryBody()
        }
        
        
    }
    
    
    
    private func foodEntryBody() -> some View {
        HStack {
            date()
            Spacer()
            foodName()
        }
    }
    
    private func bathroomEntryBody() -> some View {
        HStack {
            date()
            Spacer()
            tag()
        }
    }
    
    func date() -> some View {
        let date = format(date: unwrap(value: .date))
        return Text(date)
    }
    
    func tag() -> some View {
        return Text(unwrap(value: .tag) )
    }
    
    func foodName() -> some View {
        return Text(unwrapFoodName() ?? unwrap(value: .tag))
    }
    
    // Fetch name of food
    private func unwrapFoodName() -> String? {
        var name: String?
        guard let foodEntry = foodEntry, let foodID = foodEntry.foodID else { return nil }
        let foods = Foods()
        guard let food = foods.fetchFood(id: foodID) else { return nil }
        name = food.name
        return name
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

//struct HistoryListElement_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryListElement(<#FoodEntry#>)
//    }
//}
