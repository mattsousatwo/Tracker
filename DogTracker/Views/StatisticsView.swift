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
    @ObservedObject var dogs = Dogs()
    
    @State private var firstDate: Date = Date()
    @State private var lastDate: Date = Date()
    
    @State var viewMode: Int = 0
    @State var mode: Bool = true
    let trackerConversion = TrackerConversion()
    
    @State var present: Bool = false
    
    @State var backgroundColor: Color = .backgroundGray
    
    @State var selectedDog = Dog()
    @State var selectedDogName = ""
    
    @State var selectedDogImage: UIImage? = nil
    
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
                            
                            
                            HStack {
                                
                                Text(selectedDogName).font(.title)
                                    .padding(.bottom)
                                    .padding(.leading)
                                
                                
                                Spacer()
                            }
                            
                            
                            
                            DogSwitcher(selectedDog: $selectedDog, image: selectedDogImage)
                                .animation(.default)
                                .onAppear {
                                    guard let favorite = dogs.fetchFavoriteDog() else { return }
                                    selectedDog = favorite
                                    if let name = selectedDog.name {
                                        selectedDogName = name
                                    }
                                    if dogs.allDogs.count == 0 {
                                        dogs.fetchAll()
                                    }
                                    
                                    guard let image = favorite.convertImage() else { return }
                                    withAnimation {
                                        self.selectedDogImage = image
                                    }
                                }
                            
                            
                            
                            
                        }
                        VStack(alignment: .leading) {
                            StatsBar()
                                .onAppear {
                                    DispatchQueue.global(qos: .userInteractive).async {
                                        trackerConversion.getFrequencyOfBathroomUse()
                                    }
                                    
                                }
                            WeatherView()
                                .padding()
                            
                                BathroomUsageGraph(selectedDog: $selectedDog)
                                    .padding()
                            
                        }
                        
                    }
                }
                
            }
            .onChange(of: selectedDog) { (_) in
                if let dogName = selectedDog.name {
                    selectedDogName = dogName
                }
                
                dogs.updateFavorite(dog: selectedDog, in: dogs.allDogs)
                
                
                if let dogImage = selectedDog.convertImage() {
                    withAnimation {
                        self.selectedDogImage = dogImage
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
