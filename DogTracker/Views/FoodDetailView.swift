//
//  FoodDetailView.swift
//  FoodDetailView
//
//  Created by Matthew Sousa on 8/30/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct FoodDetailView: View {
    
    var food: Food 
    
    var body: some View {
        
        
        Text("\(food.name ?? "No Name")")
        
    }
}

//struct FoodDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodDetailView()
//    }
//}
