//
//  RowWithIcon.swift
//  RowWithIcon
//
//  Created by Matthew Sousa on 9/12/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct RowWithIcon<field>: View where field: View {
    
    let textfield: () -> field
    
    var image: String?
    
    init(image: String? = nil, @ViewBuilder field: @escaping () -> field) {
        self.image = image
        self.textfield = field
    }
    
    
    var body: some View {
        
        HStack {
            
            Icon(image: image,
                 color: .lightBlue)
        
            textfield()
                
        }
        
        
        
        
    }
}

struct RowWithIcon_Previews: PreviewProvider {
    static var previews: some View {
        RowWithIcon(image: "scalemass") {
            Text("My textRow")
        }
    }
}
