//
//  UpdateProfileView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/27/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct UpdateProfileView: View {
    
    var updateStyle: UpdateType
    
    @State private var string: String = ""
    @State private var newString: String = ""
    @State private var finalString: String = ""
    
    @State private var stringAccepted: Bool = false
    
    var body: some View {
        
        Form {
            
            Section(header: Text("Update \(updateStyle.rawValue)") ) {
                
                TextField("Current \(updateStyle.rawValue):", text: $string)
                    .padding()
                
                TextField("Change \(updateStyle.rawValue) to:", text: $newString)
                    .padding()
                
                TextField("Confirm \(updateStyle.rawValue):", text: $finalString)
                    .padding()
            }
            
            Section {
            // Save button
            Button("Save") {
                
                if self.newString == self.finalString {
                    print("Save: \(self.finalString)")
                    self.stringAccepted = true
                    // SAVE FUNCTION
                } else {
                    self.stringAccepted = false
                    // Vibrate
                    // Animate: Button color to red w| black text
                }
                                
            }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(Color.white)
                .font(.headline)
                .cornerRadius(15)
                .shadow(radius: 2)
            
            } // Section
            
            
            
        } // Form
        
        
        
        
        
    }
}

struct UpdateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfileView(updateStyle: UpdateType.name)
    }
}


