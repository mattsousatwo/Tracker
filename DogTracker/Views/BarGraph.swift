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
    var background: [Color] = [.lightPurple, .darkBlue ]
    
    var colors: [Color] = [.red, .green, .purple, .black, .darkGreen, .orange, .darkRed]
    var values: [CGFloat] = [100, 200, 110, 85, 50, 105, 130]
    
    
    
    
    var body: some View {
       
        ZStack {
            LinearGradient(gradient: Gradient(colors: background),
                            startPoint: .bottom,
                            endPoint: .top)
                .frame(width: width,
                           height: height)
                .cornerRadius(12)
                .overlay(
                    
                    VStack {

                        
                        // Bars
                        HStack(alignment: .bottom, spacing: 10) {
                            
                            ForEach(values, id: \.self) { value in
                                // Use ForEach to set this up
                                VStack {
                                    Text("\(value)")
                                        .foregroundColor(.white)
                                        .opacity(0.7)
                                        .font(.system(size: 10))
                                        .lineLimit(1)
                                    
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: self.width / 15, // Size
                                                height: value ) // Bar Value - BAR ENTRY.VALUE
                                        .foregroundColor(self.barColor)
                                    
                                    
                                    
                                } // VStack
                            } // ForEach
                        } // HStack - Bars
                            .padding(.horizontal)
                            
                            
                        // Labels
                        HStack(alignment: .bottom, spacing: 5) {
                            ForEach(values, id: \.self) { value in
                                Text("\(value)")
                                    .font(.system(size: 15))
                                    .lineLimit(1)
                                    .foregroundColor(.white)
                                    .opacity(0.7)
                                
                            } // ForEach
                                .padding(.horizontal)
                                .padding(.bottom)
                        } // HStack - Labels
                            
                        
                        
                        
                    } // VStack
                    
                    , alignment: .bottom) // Overlay
            
        } // ZStack
        
         
    } // Body
}

struct BarGraph_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BarGraph(width: 400, height: 400).previewLayout(.sizeThatFits)
            TimeBarGraph(width: 400, height: 400).previewLayout(.sizeThatFits)
            
        }
        
    }
}




