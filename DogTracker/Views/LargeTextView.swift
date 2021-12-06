//
//  LargeTextView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 12/5/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct LargeTextView: View {
    
    @Binding var text: String
    var placeholder: String = "Notes"
    var height: CGFloat = 250
    @State private var textColor: UIColor = .lightGray
    
    
    var body: some View {
        TextEditor(text: $text)
            .foregroundColor(Color(textColor) )
            .frame(height: height,
                   alignment: .center)
            .padding(.horizontal, 5)
            .onAppear {
                setPlaceholderValue()
                setTextColor()
            }
            .onChange(of: text) { _ in
                setTextColor()
            }

        
    }
    
    func setPlaceholderValue() {
        if text == "" {
            text = placeholder
        }
    }
    
    func setTextColor() {
        switch text {
        case placeholder:
            textColor = .lightGray
        default:
            textColor = UIColor(Color.primary)
            
        }
    }
    
}

@available(iOS 14.0, *)
struct LargeTextView_Previews: PreviewProvider {
    static var previews: some View {
        LargeTextView(text: .constant(""))
    }
}
