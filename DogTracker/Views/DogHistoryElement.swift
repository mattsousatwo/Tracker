//
//  DogHistoryElement.swift
//  DogTracker
//
//  Created by Matthew Sousa on 11/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

struct DogHistoryElement: Hashable  {
    
    private var bathroomEntry: BathroomEntry?
    private var foodEntry: FoodEntry?
    var id = UUID().uuidString
    
    var entry: HistoryElementEntry {
        if bathroomEntry != nil {
            return bathroomEntry!
        } else {
            return foodEntry!
        }
    }
    
    init(bathroomEntry: BathroomEntry) {
        self.bathroomEntry = bathroomEntry
    }
    
    init(foodEntry: FoodEntry) {
        self.foodEntry = foodEntry
    }
    
}


extension BathroomEntry: HistoryElementEntry  {
    
}

extension FoodEntry: HistoryElementEntry {
    
}

protocol HistoryElementEntry {
    
}
