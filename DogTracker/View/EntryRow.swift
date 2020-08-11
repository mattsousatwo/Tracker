//
//  EntryRow.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/11/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct EntryRow: View {
    // To store selected segment
    @State private var type = 0
    // To label the segment
    var label: String
    // All segments for the controller
    var bathroomTypes: [String]
    
    var body: some View {
        HStack {
        Text(label)
        .padding()
            
            // ERROR - Looks like label doesnt get used
            Picker(selection: $type, label: Text(label)) {
                ForEach(0..<bathroomTypes.count) { index in
                    Text(self.bathroomTypes[index]).tag(index)
                    .padding()
                    
                }
            }.pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct EntryRow_Previews: PreviewProvider {
    static var previews: some View {
        EntryRow(label: "Something here", bathroomTypes: ["Option 1", "Option 2 "])
    }
}
 
