//
//  DogImage.swift
//  DogTracker
//
//  Created by Matthew Sousa on 11/5/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

protocol DogImage {
    
    associatedtype someView: View
    func dogProfile(image: UIImage?, _ size: CGFloat) -> someView
    
}

extension DogImage {

    func dogProfile(image: UIImage?, _ size: CGFloat) -> some View  {
        var dogImage = UIImage(named: "Sand-Dog")!
        if let image = image {
            dogImage = image
        }
        let y =  Image(uiImage: dogImage)
            .resizable()
            .clipShape(Circle() )
            .aspectRatio(contentMode: .fit)
            .frame(width: size,
                   height: size,
                   alignment: .topLeading)
            .padding()
//            .shadow(radius: 5) as! Image
        return y
    }
    
    
}

