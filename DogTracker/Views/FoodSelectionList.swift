//
//  FoodSelectionList.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/21/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct FoodSelectionList: View {
    
    @Binding var favoriteFood: String
    @Binding var isPresented: Bool
    
    // let food = Food()
    
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        List {
            Text("F")
        }
    }
}

struct FoodSelectionList_Previews: PreviewProvider {
    static var previews: some View {
        FoodSelectionList(favoriteFood: .constant("P"), isPresented: .constant(true))
    }
}
