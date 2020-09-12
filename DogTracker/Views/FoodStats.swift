//
//  FoodStats.swift
//  DogTracker
//
//  Created by Matthew Sousa on 9/8/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct FoodStats: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {

            ProgressCard(progress: .constant(0.6),
                         bg: [.darkRed, .lightRed],
                         title: "Time Until Next Feeding",
                         heading: "Food",
                         footer: "at: 12:23PM")
                .padding()
            
            
            StatisticsCard()
                .padding(.horizontal)
                
  
            ProgressCard(progress: .constant(0.3),
                         bg: [.darkBlue, .lightPurple],
                         title: "Time Until Next Water Break",
                         heading: "Water",
                         footer: "at: 1:06PM")
                .padding()
            
            
                    
//            ProgressCard(bg: [.lightRed, .darkRed])
                    
//            ProgressCard(bg: [.lightGreen, .darkGreen])
                        
                Spacer()
            
        } // Scroll
                
            .navigationBarTitle(Text( "Statistics") )

                    
            .background(LinearGradient(gradient: Gradient(colors: [Color(.systemGray4), Color(.systemGray5)]), startPoint: .bottom,
                        endPoint: .top))
            .edgesIgnoringSafeArea(.bottom)
        
        
        
    } // body
} // FoodStats

struct FoodStats_Previews: PreviewProvider {
    static var previews: some View {
        FoodStats()
    }
}
