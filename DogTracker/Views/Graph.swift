//
//  Graph.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/9/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct Graph: View {
    
    var width: CGFloat {
        return UIScreen.main.bounds.width - 20
    }
    var height: CGFloat = 400
    
    var xAxisCount: CGFloat {
        return width / 7
    }
    var yAxisCount: CGFloat {
        return height / 10
    }
    
    
    var body: some View {
        
        ZStack {
            
            HStack {
                ForEach(0...Int(xAxisCount), id: \.self) {  index in
                    RoundedRectangle(cornerRadius: 0)
                        .frame(width: 10,
                               height: 10)
                        .foregroundColor(.blue)
                }
            }
        }
        
        
        RoundedRectangle(cornerRadius: 12)
            .frame(width: width,
                   height: height)
        
            
                   
        
    }
}

struct Graph_Previews: PreviewProvider {
    static var previews: some View {
        Graph()
    }
}

struct Coordinate {
    let x: Int
    let y: Int
}
