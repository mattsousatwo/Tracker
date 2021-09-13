//
//  TextFieldRow.swift
//  TextFieldRow
//
//  Created by Matthew Sousa on 9/12/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct TextFieldRow: View {
     
    
    
    var image: String?
    
    var placeholder: String?
    @Binding var fieldString: String
    var keyboardType: UIKeyboardType?
    var textAlignment: TextAlignment = .trailing
    
    var body: some View {
        
        HStack {
            if let image = image {
                Icon(image: image,
                     color: .lightBlue)
            }
            
            TextField(placeholder ?? "",
                      text: $fieldString)
                .multilineTextAlignment(textAlignment)
                .keyboardType(keyboardType ?? .default)
                .padding()
            
        }
        
        
        
        
    }
}

struct TextFieldRow_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldRow(image: "scalemass",
                     fieldString: .constant("Feild String"))
        
    }
}
