//
//  TestRect.swift
//  DogTracker
//
//  Created by Matthew Sousa on 9/9/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct TestRect: View {
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(.lightBlue)
                .frame(width: UIScreen.main.bounds.width,
                       height: 300)
                .cornerRadius(20, corners: [.bottomLeft] )
                .overlay(
                Rectangle()
                    .aspectRatio(contentMode: .fill)
                    
                    .foregroundColor(.lightBlue)
                    
                    .frame(width: 100,
                           height: 100)
                    .position(CGPoint(x: UIScreen.main.bounds.width - 50,
                                      y: 350))
                        
                    .overlay(
                        Circle()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100,
                                   height: 100)
                            .position(CGPoint(x: UIScreen.main.bounds.width - 50,
                                              y: 350) )
                            .foregroundColor(.white)

                        )
                    
            )
            

            
            
        } // VStack
        
        
    }
}

struct TestRect_Previews: PreviewProvider {
    static var previews: some View {
        TestRect()
    }
}


extension View {
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    
}


struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
    
    
}
