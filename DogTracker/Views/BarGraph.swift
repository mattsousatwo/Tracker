//
//  BarGraph.swift
//  DogTracker
//
//  Created by Matthew Sousa on 9/12/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct BarGraph: View {
    
    var width: CGFloat
    var height: CGFloat
    
    var entries: Int = 7
    
    var barColor: Color = .darkBlue
    
    var body: some View {
       
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: width, height: height)
                .foregroundColor(Color.lightBlue)
                .overlay(
                    
                    
                    HStack(alignment: .bottom, spacing: 20) {
                        
                        // Use ForEach to set this up
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: width / 12, // Size
                                height: 155 ) // Bar Value
                            .foregroundColor(barColor)
                        
                        // 2
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: width / 12, // Size
                                height: 96 ) // Bar Value
                            .foregroundColor(barColor)
                        
                        // 3
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: width / 12, // Size
                                height: 180) // Bar Value
                            .foregroundColor(barColor)
                        
                        // 4
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: width / 12, // Size
                                height: 20 ) // Bar Value
                            .foregroundColor(barColor)
                        
                        // 5
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: width / 12, // Size
                                height: 200 ) // Bar Value
                        .foregroundColor(barColor)
                        
                        
                        // 6
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: width / 12, // Size
                                height: 160 ) // Bar Value
                        .foregroundColor(barColor)
                        
                        // 7
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: width / 12, // Size
                                height: 140 ) // Bar Value
                        .foregroundColor(barColor)

                            
                    
                    }
                    .padding()
                    
                    
                    
                    , alignment: .bottom
                ) // Overlay
            
        } // ZStack
        
         
    } // Body
}

struct BarGraph_Previews: PreviewProvider {
    static var previews: some View {
        BarGraph(width: 400, height: 400).previewLayout(.sizeThatFits)
    }
}
