//
//  TestShape.swift
//  DogTracker
//
//  Created by Matthew Sousa on 9/10/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct TestShape: View {
    var body: some View {

        
        MyShape()
            .stroke(style: StrokeStyle(lineWidth: 10,
                                       lineCap: .round,
                                       lineJoin: .round) )
            .foregroundColor(.lightBlue)
        
        
        
        
    } // body
    
}

struct TestShape_Previews: PreviewProvider {
    static var previews: some View {
        TestShape().previewLayout(.sizeThatFits)
    }
}


struct MyShape: Shape {
    
    var startPoint: CGFloat = 0
    var endPoint: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        
        Path { path in
            
            path.move(to: CGPoint(x: rect.size.width,
                                  y: 0))
            path.addLine(to: CGPoint(x: 0,
                                     y: 0))
            path.addLine(to: CGPoint(x: 0,
                                     y: rect.size.width))
            
            path.addCurve(to: CGPoint(x: rect.size.width, y: 0),
                          control1: CGPoint(x: rect.size.width, y: 0),
                          control2: CGPoint(x: rect.size.width, y: 0))
        
        }

    }
    
    
    
}
