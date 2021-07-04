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
    let trackerConversion = TrackerConversion()
    
    var body: some View {
        VStack(alignment: .leading) {
            WeatherView()
                .padding()
            StatsBar()
                .onAppear {

                    trackerConversion.getFrequencyOfBathroomUse()
                }
            
            NavigationLink(destination: HistoryView()) {
                Text("History")
                    .padding()
            }
        }
        
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


