//
//  BoolSegmentRow.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/21/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct BoolSegmentRow: View {
    
    @Binding var bindingType: Int
    
    // To label the segment
    var label: String
    // All segments for the controller
    var option1: String
    var option2: String
    
    // get values of option1 and option2 and set as array
    private var segmentArray: [String] {
        get {
            return [option1, option2]
        }
    }
    
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

struct BoolSegmentRow_Previews: PreviewProvider {
    static var previews: some View {
        PreviewBoolWrapper()
       // BoolSegmentRow()
    }
    
    struct PreviewBoolWrapper: View {
        @State(initialValue: 0) var code: Int
        var body: some View {
            BoolSegmentRow(bindingType: $code, label: "Title", option1: "1", option2: "2")
            
            
        }
    }
}
