//
//  FoodList-Protocol.swift
//  FoodList-Protocol
//
//  Created by Matthew Sousa on 9/9/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation


protocol FoodList {
    
    /// if deleting a row
    func delete(at set: IndexSet)
    
    /// if deleting last row
    func onLastDelete()
    
    /// Comapare existing favorite food with favorite food in foodList
    func updateFavoriteSelection()
    
    
    
}
