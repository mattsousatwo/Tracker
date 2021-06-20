//
//  HistoryView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/21/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {
    
    
    @State var viewMode: Int = 0

    var body: some View {
        
        VStack {
            Picker(selection: $viewMode,
                   label: Text("") ,
                   content: {
                    Image(systemName: "folder").tag(0) // Bathroom
                    Image(systemName: "pencil").tag(1) // Food
            })
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            
            
            NextBathroomCard()

            
            
            
 
//            ScrollView(.vertical, showsIndicators: false) {
                
                if viewMode == 0 {
                    BathroomStats()
                } else {
                    FoodStats()
                }
            
            
//            } // Scroll
            
                

                
//                .background(LinearGradient(gradient: Gradient(colors: [Color(.systemGray4), Color(.systemGray5)]), startPoint: .bottom,
//                    endPoint: .top))
        } // VStack

        
    } // Body
     
    
} // History

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticsView().previewLayout(.sizeThatFits)
            
            StatisticsView(viewMode: 1).previewLayout(.sizeThatFits)
        }
            
        
    }
}


