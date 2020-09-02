//
//  Icon.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/29/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct Icon: View {
    
    var image: String
    var color: Color
    
    var body: some View {
        Image(systemName: image)
            .frame(width: 40, height: 40)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(5)
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon(image: "person", color: .yellow)
    }
}
