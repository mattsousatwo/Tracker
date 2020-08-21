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
    
//    init(bindingType: Binding<Bool>, label: String, option1: String, option2: String) {
//        self.label = label
//        self.option1 = option1
//        self.option2 = option2
//
//        self.bindingType = bindingType.value
//        self.segmentArray = [self.option1, self.option2]
//        // bindingType: , label: "Title", option1: "1", option2: "2"
//
//    }
    
//    private var segmentArray: [String] = [self.option1, self.option2]
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
