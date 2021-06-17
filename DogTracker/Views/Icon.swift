//
//  Icon.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/29/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct Icon: View {
    
    var image: String? = nil
    var color: Color = .clear
    var frame: CGFloat = 40
    
    var body: some View {
        if let image = image {
            Image(systemName: image)
                .frame(width: frame, height: frame)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(5)
        } else {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: frame, height: frame)
                .background(color)
                .foregroundColor(color)
                .padding(5)
        }
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon(image: "person", color: .yellow)
    }
}
