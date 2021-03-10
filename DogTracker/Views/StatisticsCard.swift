//
//  StatisticsCard.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/27/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct StatisticsCard: View {
    
    @State var displayMode: Int = 0
    
    var body: some View {
        
//        GeometryReader { geometry in
                
            VStack {
                Text("Statistics Card").font(.system(.title)).fontWeight(.semibold)
                    .shadow(radius: 10)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    
                
                VStack {
                    
                    Picker(selection: self.$displayMode, label: Text("Mode") ) {
                        Text("Frequency").tag(0)
                        Text("Time").tag(1)
                    }.pickerStyle(SegmentedPickerStyle())
                        .animation(.easeIn)
                        .padding(.bottom)
                    
                    if self.displayMode == 0 {
                        BarGraph(width: UIScreen.main.bounds.width - 30,
                                 height: 300)
                    } else {
                        TimeBarGraph(width: UIScreen.main.bounds.width - 30,
                                     height: 300)

                    }
                    

                    
                }// VStack
    
                
                    Spacer()
                
                HStack {
                    Text("Amount of Breaks per day: ").font(.system(.headline))
                    Spacer()
                    Text("9").font(.system(.headline))
                } // Row 1
                    .padding()
                    
                HStack {
                    Text("Time between Breaks: ").font(.system(.headline))
                    Spacer()
                    Text("1:45 Mins").font(.system(.headline))
                } // Row 2
                    .padding()
                    
                    
                HStack {
                    Text("Accidents this month: ").font(.system(.headline))
                    Spacer()
                    Text("19").font(.system(.headline))
                } // Row 3
                    .padding()
                    
                    
                    
            
            } // VStack

                .frame(width: UIScreen.main.bounds.width - 30, height: 600)
//                .background(LinearGradient(gradient: Gradient(colors:
//                                        [.darkBlue, .lightBlue]),
//                                           startPoint: .bottom,
//                                           endPoint: .top) )
                .cornerRadius(20)
//                .shadow(color: Color.white, radius: 2, x: -3, y: -3)
//                .shadow(color: Color.gray, radius: 2, x: -3, y: -3)
                .padding()
//        } // Geo Reader
        
    
    } // body
} // StatsCard

struct StatisticsCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticsCard().previewLayout(.sizeThatFits)
            
            StatisticsCard(displayMode: 1).previewLayout(.sizeThatFits)
        }
        
    }
}
