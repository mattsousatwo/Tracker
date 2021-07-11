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
    
    @State var present: Bool = false
    
    var body: some View {
        if #available(iOS 14.0, *) {
            ZStack {
                
                Color.backgroundGray
                    .ignoresSafeArea(.all, edges: .all)
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("Welcome,")
                                .fontWeight(.light)
                                .padding()
                            Spacer()
                        }
                        HStack {
                            Text("Matthew").font(.title)
                                .padding(.bottom)
                                .padding(.leading)
                            Spacer()
                            
                            Button {
                                self.present.toggle()
                            } label: {
                                Icon(image: "list.dash",
                                     color: .dBlue,
                                     frame: 50)
                                    .padding()
                            }.sheet(isPresented: $present, content: {
                                HistoryView()
                            })
                            
                        }
                    }
                    VStack(alignment: .leading) {
                        WeatherView()
                            .padding()
                        StatsBar()
                            .onAppear {
                                
                                trackerConversion.getFrequencyOfBathroomUse()
                            }
                        
                        
                        //            NavigationLink(destination: HistoryView()) {
                        //                Text("History")
                        //                    .padding()
                        //            }
                        
                        
                    }
                    
                }
                
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


