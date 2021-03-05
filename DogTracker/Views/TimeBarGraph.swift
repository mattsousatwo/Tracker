//
//  TimeBarGraph.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/5/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

/// Layered bar graph to show
struct TimeBarGraph: View {
    
    // size
    var width: CGFloat
    var height: CGFloat
    
    // Coloring
    var background: [Color] = [.darkBlue, .lightPurple]
    var barColors: [Color] = [.lightBlue, .azure, .darkBlue]
    
    // Content
    var values: [CGFloat] = [100, 200, 110, 85, 50, 105, 130]
    var values2: [CGFloat] = [150, 220, 140, 100, 70, 125, 150]
    var values3: [CGFloat] = [180, 260, 200, 170, 170, 165, 180]
    
    // Configuration
    var barSpacing: CGFloat = 12 // HStack alignment spacing
    var horizontalPadding: CGFloat = 8 // Horizontal padding for each bar
    var textBoxWidth: CGFloat = 30 // width for textbox
    var textBoxHeight: CGFloat = 30 // width for textbox
    
    var body: some View {

        // Background
        LinearGradient(gradient: Gradient(colors: background),
                        startPoint: .bottom,
                        endPoint: .top)
            .frame(width: width,
                       height: height)
            .cornerRadius(12)
            .overlay(
                VStack {
                    
                    
                    ZStack(alignment: .bottom) {
                        
                        
                                            
                        // Back Row - Night, Max value
                        
                                                    
                        HStack(alignment: .bottom, spacing: barSpacing) {
                                                        
                            ForEach(values3, id: \.self) { value in
                                Bar(title: "\(value)",
                                    height: value,
                                    barColor: self.barColors[2],
                                    barWidth: self.width / 15,
                                    textBoxWidth: self.textBoxWidth,
                                    textBoxHeight: self.textBoxHeight)
                  
                                } // ForEach
                                    .padding(.horizontal, horizontalPadding)
                            } // HStack - Bars
                                
      
                        
                        
                        
                        /// ________________________________________________________
      
                        // Mid Row - Midday, Mid value
                        HStack(alignment: .bottom, spacing: barSpacing) {
                                    
                            ForEach(values2, id: \.self) { value in
                                // Use ForEach to set this up
                                VStack {
                                    
                                    Bar(title: "\(value)",
                                        height: value,
                                        barColor: self.barColors[1],
                                        barWidth: self.width / 15,
                                        textBoxWidth: self.textBoxWidth,
                                        textBoxHeight: self.textBoxHeight)
                                    
                                } // VStack
                            } // ForEach
                                .padding(.horizontal, horizontalPadding)
                        } // HStack - Bars
                            
       
                        /// ________________________________________________________
                        
                        // Front Row - Morning, Min value
                        
                                
                        HStack(alignment: .bottom, spacing: barSpacing) {
                                    
                            ForEach(values, id: \.self) { value in
                                // Use ForEach to set this up
                                VStack {
                                    
                                    Bar(title: "\(value)",
                                        height: value,
                                        barColor: self.barColors[0],
                                        barWidth: self.width / 15,
                                        textBoxWidth: self.textBoxWidth,
                                        textBoxHeight: self.textBoxHeight)
                                    
                                } // VStack
                            } // ForEach
                                .padding(.horizontal, horizontalPadding)
                        } // HStack - Bars
                            
                                
                        /// ________________________________________________________
                        
                            
                    } // ZStack - Content
                        
                    HStack(alignment: .bottom, spacing: barSpacing) {
                        ForEach(values, id: \.self) { value in
                            Text("Mon") // value.day
                                    .frame(width: self.textBoxWidth,
                                            height: self.textBoxHeight)
                                    .font(.system(size: 10))
                                    .opacity(0.7)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .shadow(radius: 5)
                                    
                        } // forEach
                            .padding(.horizontal, horizontalPadding)
                    } // HStack
                
                } // VStack
                
            , alignment: .bottom ) // overlay - background
            
        
    } // body
    
    
    
    
} // TimeBarGraph

struct TimeBarGraph_Previews: PreviewProvider {
    static var previews: some View {
        TimeBarGraph(width: 400,
                     height: 400)
            
            .previewLayout(.sizeThatFits)
    }
}
