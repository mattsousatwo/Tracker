//
//  TimeRow.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/12/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct TimeRow: View {
    
    @State private var min = Date()
    
    
    
    
    var body: some View {
        
        VStack {
            Button(action: {
                self.min = Date()
            }) {
                Text("Set to current time")
                .padding()
//                    .frame(width: 200, height: 45, alignment: .center)
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .font(Font.system(size: 20))
                .cornerRadius(15)
                
            }
            
            
            VStack {
                Text("")
                .padding()
//                  TextField(label, text: $bindingString)
                DatePicker("Time", selection: $min, displayedComponents: .hourAndMinute)
                                
                Text("Current Selected Time is \(min)")
                    .frame(alignment: .center)
                                
                        
            }
        }
        
    }
}

struct TimeRow_Previews: PreviewProvider {
    static var previews: some View {
        TimeRow()
    }
}
