//
//  BathroomUsageGraph.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/5/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

/// Layered bar graph to show
struct BathroomUsageGraph: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    // size
    var width: CGFloat
    var height: CGFloat
    
    // Coloring
    @State private var backgroundColor: Color = .white
    var barColors: [Color] = [.lightBlue, .azure, .darkBlue]
    
    // Content
    var values: [CGFloat] = [100, 200, 110, 85, 50, 105, 130]
    var days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    // Configuration
    var barSpacing: CGFloat = 12 // HStack alignment spacing
    var horizontalPadding: CGFloat = 8 // Horizontal padding for each bar
    var textBoxWidth: CGFloat = 30 // width for textbox
    var textBoxHeight: CGFloat = 30 // width for textbox
    
    func updateBackgroundColor() {
        switch colorScheme {
        case .light:
            backgroundColor = .black
        case .dark:
            backgroundColor = .backgroundGray
        default:
            backgroundColor = .backgroundGray
        }
    }
    
    func updateBackgroundOnAppear() {
        switch colorScheme {
        case .dark:
            backgroundColor = .black
        case .light:
            backgroundColor = .backgroundGray
        default:
            backgroundColor = .backgroundGray
        }
    }
    @State private var popover: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("My Activity:").font(.system(size: 25,
                                                 weight: .medium,
                                                 design: .rounded))
                    
                Spacer()
                
                Button {
                    self.popover.toggle()
                } label: {
                    Text("Dog Name")
                }
                
                
            }
            // Background
            if #available(iOS 14.0, *) {
                backgroundColor
                    .onAppear {
                        updateBackgroundOnAppear()
                    }
                    
                    .onChange(of: colorScheme, perform: { value in
                        updateBackgroundColor()
                    })
                    
                    .frame(width: width,
                           height: height)
                    .cornerRadius(12)
                    .overlay(
                        VStack {
                            
                            
                            ZStack(alignment: .bottom) {
                                
                                
                                // Front Row - Morning, Min value
                                
                                
                                HStack(alignment: .bottom, spacing: barSpacing) {
                                    
                                    ForEach(values, id: \.self) { value in
                                        // Use ForEach to set this up
                                        VStack {
                                            
                                            Bar(title: "\(value)",
                                                height: value,
                                                barColor: self.barColors[0],
                                                barWidth: self.width / 25,
                                                textBoxWidth: self.textBoxWidth,
                                                textBoxHeight: self.textBoxHeight)
                                            
                                        } // VStack
                                    } // ForEach
                                    .padding(.horizontal, horizontalPadding)
                                } // HStack - Bars
                                
                                
                                /// ________________________________________________________
                                
                                
                            } // ZStack - Content
                            
                            HStack(alignment: .bottom, spacing: barSpacing) {
                                ForEach(days, id: \.self) { day in
                                    Text(day) // value.day
                                        .frame(width: self.textBoxWidth,
                                               height: self.textBoxHeight)
                                        .font(.system(size: 10))
                                        .opacity(0.7)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                        .shadow(radius: 5)
                                    
                                } // forEach
                                .padding(.horizontal, horizontalPadding)
                            } // HStack
                            
                        } // VStack
                        
                        , alignment: .bottom )
            } else {
                // Fallback on earlier versions
            } // overlay - background
        }
        
    } // body
    
    
    
    
} // BathroomUsageGraph

struct BathroomUsageGraph_Previews: PreviewProvider {
    static var previews: some View {
        BathroomUsageGraph(width: 400,
                     height: 400)
            
            .previewLayout(.sizeThatFits)
    }
}
