//
//  StatisticsCard.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/27/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct StatisticsCard: View {
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                
                VStack {
                    HStack {
                        Text("Title")
                        Spacer()
                    }
                    // seg
                }
                // Segment
                
                // Graph
                
                
            } // ZStack
                .frame(width: geometry.size.width - 30, height: 500)
                .background(Color("LairBackgroundGray"))
                .cornerRadius(20)
                .shadow(color: Color.white, radius: 2, x: -3, y: -3)
                .shadow(color: Color.gray, radius: 2, x: -3, y: -3)
        } // Geo Reader
    
    } // body
} // StatsCard

struct StatisticsCard_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsCard()
    }
}
