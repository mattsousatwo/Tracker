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
    @State var mode: Bool = true
    
    var body: some View {
        
        Form {
//            Picker(selection: $viewMode,
//                   label: Text("") ,
//                   content: {
//                    Image(systemName: "folder").tag(0) // Bathroom
//                    Image(systemName: "pencil").tag(1) // Food
//                   })
//                .pickerStyle(SegmentedPickerStyle())
            //                .padding()
            Section(header:
                Toggle(isOn: $mode,
                       label: {
                        
                        
                       })
                    //            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .padding(.bottom, 5)
            ) {
  
                NextBathroomCard()
            }
            
            if mode == true {
                BathroomStats()
            } else {
                FoodStats()
            }
            
            
            
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


