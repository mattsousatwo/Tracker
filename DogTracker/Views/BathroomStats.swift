//
//  BathroomStats.swift
//  DogTracker
//
//  Created by Matthew Sousa on 9/8/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct BathroomStats: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {

            ProgressCard(progress: .constant(0.1), bg: [.darkBlue, .lightBlue])
                .padding(.horizontal)
                .padding(.top)
            
            StatisticsCard()
                .padding()
                
            
                    
        //            ProgressCard(bg: [.lightRed, .darkRed])
                    
        //            ProgressCard(bg: [.lightGreen, .darkGreen])
                        
                        
        } // Scroll
                
            .navigationBarTitle(Text( "Statistics") )

                    
            .background(LinearGradient(gradient: Gradient(colors: [Color(.systemGray4), Color(.systemGray5)]), startPoint: .bottom,
                        endPoint: .top))
            .edgesIgnoringSafeArea(.bottom)
        
        
        
    } // Body
} // BathroomStats

struct BathroomStats_Previews: PreviewProvider {
    static var previews: some View {
        BathroomStats()
    }
}
