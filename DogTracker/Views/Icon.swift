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
    var padding: CGFloat?
    var buttonStatus: ButtonStatus = .active
    
    
    var body: some View {
        if let image = image {
            Image(systemName: image)
                .frame(width: frame, height: frame)
                .background(color)
                .foregroundColor(buttonStatus.asBool() ? .white : .backgroundGray)
                .cornerRadius(12)
                .padding(padding != nil  ? padding! : 0)
        } else {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: frame, height: frame)
                .background(color)
                .foregroundColor(color)
                .padding(padding != nil  ? padding! : 0)
        }
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon(image: "person", color: .green).previewLayout(.sizeThatFits)
        Icon(image: "cloud.fill", color: .blue).previewLayout(.sizeThatFits)
        Icon(image: "cloud.drizzle", color: .gray).previewLayout(.sizeThatFits)
    }
}

enum ButtonStatus {
    case active
    case inactive
    
    func asBool() -> Bool {
        switch self {
        case .active:
            return true
        case .inactive:
            return false
        }
    }
}
