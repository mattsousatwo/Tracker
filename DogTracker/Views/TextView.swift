//
//  TextView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/22/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    var textStyle: UIFont.TextStyle = .body
    var placeholder: String = "Notes"
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.font = UIFont.preferredFont(forTextStyle: textStyle)
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = UIColor.clear
        
        textView.text = placeholder
        textView.textColor = UIColor.lightGray

        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if text == "" ||
            text == placeholder {
            uiView.text = placeholder
            uiView.textColor = UIColor.lightGray
            
        }
        
        
        
        if text != "" &&
            text != placeholder {
            
            uiView.text = text
            uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
            uiView.textColor = UIColor.black
//            if #available(iOS 14.0, *) {
//                uiView.textColor = UIColor(Color.primary)
//            }
//            print("text = \(text), uiview.text = \(uiView.text)")
        }
        
        

    }
    
    
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            TextView(text: .constant(""))
            TextView(text: .constant("Malamar")).colorScheme(.dark)
        }.previewLayout(.fixed(width: 300, height: 200))
    }
}
