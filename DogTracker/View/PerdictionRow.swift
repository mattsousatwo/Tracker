//
//  PerdictionRow.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/21/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct PerdictionRow: View {
    var topColor: Color
    var bottomColor: Color
    
    //
    var time: String
    
    var body: some View {
  
            HStack {
                
                VStack {
                    
                    Image("globe").resizable()
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                        .padding(.leading)
                    
                }// VStack
 
                    .padding(.leading)
                
                Spacer()
                
                VStack {
                    Text("Next pee at")
                        
                        .padding(.top)
                    Text(time).bold()
                        .padding(.trailing)
                }
                
                
                Spacer()
                
            } // HStack
                .frame(width: 250, height: 100)
                .background(LinearGradient(gradient: Gradient(colors: [topColor, bottomColor]), startPoint: .top, endPoint: .bottom ) )
                .cornerRadius(18)
        
    } // Body
        
} // PerdictionRow

struct PerdictionRow_Previews: PreviewProvider {
    static var previews: some View {

        PerdictionRow(topColor: Color("SlateBlue"), bottomColor: Color("DarkSlateBlue"), time: "12:40 PM")
    }
}
