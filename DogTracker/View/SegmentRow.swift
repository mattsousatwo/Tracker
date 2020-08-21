//
//  EntryRow.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/11/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct SegmentRow: View {
    // To store selected segment
    @State private var type = 0
    
    @Binding var bindingType: Int
    
    // To label the segment
    var label: String
    // All segments for the controller
    var segmentArray: [String]
    
    var body: some View {
        HStack {
        Text(label)
        .padding()
            
            // ERROR - the label parameter is unused
            Picker("Title", selection: $bindingType, content: {
                ForEach(0..<segmentArray.count) { index in
                    Text(self.segmentArray[index]).tag(index)
                        .padding()
                }
            })
                .pickerStyle(SegmentedPickerStyle())
                
            
            
        }
        
    }
}

struct EntryRow_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper() 
//        EntryRow(bindingType: , label: "Title", segmentArray: ["Option 1", "Option 2 "])
    }
    
    struct PreviewWrapper: View {
        @State(initialValue: 0) var code: Int
        var body: some View {
            SegmentRow(bindingType: $code, label: "Example", segmentArray: ["Option 1", "Option 2 "])
        }
    }
}


