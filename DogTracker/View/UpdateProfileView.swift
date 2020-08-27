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
            
        
            
            
        }
        
        
        
        
        
    }
}

struct UpdateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfileView(updateStyle: UpdateType.name)
    }
}


