//
//  HistoryView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/21/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var viewMode: Int = 0
    @State var mode: Bool = true
    let trackerConversion = TrackerConversion()
    
    @State var present: Bool = false
    
    @State var backgroundColor: Color = .backgroundGray
    
    
    func updateBackgroundColor() {
        switch colorScheme {
        case .light:
            backgroundColor = .black
        case .dark:
            backgroundColor = .backgroundGray
        default:
            backgroundColor = .backgroundGray
        }
    }
    
    func updateBackgroundOnAppear() {
        switch colorScheme {
        case .dark:
            backgroundColor = .black
        case .light:
            backgroundColor = .backgroundGray
        default:
            backgroundColor = .backgroundGray
        }
    }
    
    var body: some View {
        if #available(iOS 14.0, *) {
            ZStack {
                
                backgroundColor
                    .ignoresSafeArea(.all, edges: .all)
                    .onAppear {
                        updateBackgroundOnAppear()
                    }
                    .onChange(of: colorScheme, perform: { value in
                        updateBackgroundColor()
                    })
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
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
                            }
                            
 
                        }
                        Button {
                            self.present.toggle()
                        } label: {
                            Icon(image: "list.dash",
                                 color: .dRed,
                                 frame: 50)
                                .padding()
                        }.sheet(isPresented: $present, content: {
                            HistoryView()
                        })
                    }
                    VStack(alignment: .leading) {
                        StatsBar()
                            .onAppear {
                                
                                trackerConversion.getFrequencyOfBathroomUse()
                            }
                        WeatherView()
                            .padding()
                        
                        BathroomUsageGraph(width: UIScreen.main.bounds.width - 20,
                                           height: 300)
                            .padding()
                        
                        
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
            
//            StatisticsView(viewMode: 1).previewLayout(.sizeThatFits)
        }
        
        
    }
}


