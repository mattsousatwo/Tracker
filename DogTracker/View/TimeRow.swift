//
//  TimeRow.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/12/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct TimeRow: View {
    
    @State private var time = Date()
    var linkVariable = ""
    
    var displayTime: String {
        // formate date
        let display = "\(time)"
        
        return display
    }
    
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text("\(displayTime)")
                    .padding()
                
                NavigationLink(destination: SwiftUIView() ) {
                    Text("something")
                }
            
                
                
                    
            }
        
        }
    }
}

struct TimeRow_Previews: PreviewProvider {
    static var previews: some View {
        TimeRow()
    }
}
 
