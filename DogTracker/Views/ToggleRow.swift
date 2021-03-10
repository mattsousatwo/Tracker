//
//  ToggleRow.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/26/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct ToggleRow: View {
    // Icon name
    var icon: String? = nil
    // Background Color
    var color: Color? = nil
    // Title for row
    var title: String
    // Bool value for toggle
    @Binding var isOn: Bool
    
    var body: some View {
        
        HStack {
            if let icon = icon,
               let color = color {
                Icon(image: icon, color: color)
                    .padding(5)
            }
            Toggle(title, isOn: $isOn)
                .padding(.trailing)
        } // HStack
        
    } // Body
} // ToggleRow

struct ToggleRow_Previews: PreviewProvider {
    static var previews: some View {
        ToggleRowWrapper()
      //  ToggleRow()
        
    } // previews
    
    struct ToggleRowWrapper: View {
        @State(initialValue: false) var code: Bool
        var body: some View {
            ToggleRow(icon: "globe", color: Color.blue, title: "title", isOn: $code)
        } // body
        
    } // ToggleRowWrapper
} // ToggleRow_Previews
