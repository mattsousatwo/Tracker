//
//  Bar.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/5/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct Bar: View, Animatable {
    
    
    var title: String
    var height: CGFloat // Bar Height
    var barColor: Color = .lightGreen
    
    var barWidth: CGFloat
    var textBoxWidth: CGFloat = 30
    var textBoxHeight: CGFloat = 30
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 1) {
            Text(title)
                .frame(width: self.textBoxWidth,
                       height: self.textBoxHeight)
                .foregroundColor(.primary)
                .opacity(0.7)
                .font(.system(size: 10))
                .lineLimit(1)
                .shadow(radius: 5)
            
            
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: barWidth, // Size
                           height: height ) // Bar Value
                    .foregroundColor(barColor)
                    .animation(.linear)
            
            
            
        } // VStack
        
    }// body
} // bar

struct Bar_Previews: PreviewProvider {
    static var previews: some View {
        Bar(title: "Title",
            height: 200,
            barWidth: 100)
            .background(Color.gray)
            .previewLayout(.sizeThatFits)
    }
}
