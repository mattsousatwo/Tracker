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
    
    @State var selectedDog = Dog()
    
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
                
                VStack {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width,
                               height: 5,
                               alignment: .center)
                        .foregroundColor(backgroundColor)
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        VStack {
                            HStack {
                                Text("Welcome,")
                                    .fontWeight(.ultraLight)
                                    .padding(.leading)
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
                                 color: colorScheme == .dark ? .darkBlue : .lightBlue,
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
                        
                        BathroomUsageGraph(selectedDog: $selectedDog)
                            .padding()
                            .onAppear {
                                let dogs = Dogs()
                                
                                if let favoriteDog = dogs.getFavoriteDog() {
                                    self.selectedDog = favoriteDog
                                }
                            }
                        
                    }
                    
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


