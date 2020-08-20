//
//  SwiftUIView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/17/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct SwiftUIView: View {
        
        @State private var time = Date()
        
        var body: some View {
            
            
                Form {
                    
                    Section {
                        DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    }
                    
                    Section {
                        Button(action: {
                                self.time = Date()
                            }) {
                                Text("Set to current time")
                                    .padding()
                        //          .frame(width: 200, height: 45, alignment: .center)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(Color.white)
                                    .font(Font.system(size: 20))
                                    .cornerRadius(15)
                                        
                            }
                        
                        Text("Current Selected Time is \(time)")
                            .frame(alignment: .center)
                            .padding()
                        
                        
                    }
                    
                }
            
            
            
        }
    
    
    }


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
