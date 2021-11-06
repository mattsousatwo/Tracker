//
//  DogImage.swift
//  DogTracker
//
//  Created by Matthew Sousa on 11/5/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

// Protocol to set up any image of a dog
protocol DogImage {
    associatedtype someView: View
    func dogProfile(image: UIImage?, _ size: CGFloat) -> someView
    
}

extension DogImage {

    /// Default dog profile image implementation
    func dogProfile(image: UIImage?, _ size: CGFloat) -> some View  {
        var dogImage = UIImage(named: "Sand-Dog")!
        if let image = image {
            dogImage = image
        }
        return Image(uiImage: dogImage)
            .resizable()
            .clipShape(Circle() )
            .aspectRatio(contentMode: .fit)
            .frame(width: size,
                   height: size,
                   alignment: .topLeading)
            .padding()
    }
    
    
}

