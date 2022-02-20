//
//  HistoryView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/21/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI


@available(iOS 14.0, *)
struct StatisticsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var dogs = Dogs()
    
    @State private var firstDate: Date = Date()
    @State private var lastDate: Date = Date()
    
    
    @State var mode: Bool = true
    
    @State var present: Bool = false
    
    @State var backgroundColor: Color = .backgroundGray
    
    @State var selectedDog: Dog? = nil
    @State var selectedDogName = ""
    
    
    @State var selectedDogImage: UIImage? = nil
    
    @State var viewState: StatisticsViewState = .isLoading
    
    var body: some View {
        
        switch viewState {
        case .isLoading:
            loadingState()
                .onAppear {
                    updatePropertiesOnAppear()
                    if let _ = selectedDog {
                        viewState = .finishedLoading
                    }
                }
        case .finishedLoading:
            finishedLoadingState()
        }

        
    
    } // Body
    
} // History


// Views
@available(iOS 14.0, *)
extension StatisticsView {
    
    func loadingState() -> some View {
        backgroundColor
            .onAppear {
                viewState = .isLoading
            }
        
    }
    
    func finishedLoadingState() -> some View {
        statisticViewBody()
    }

    /// background color
    func background() -> some View {
        backgroundColor
            .ignoresSafeArea(.all, edges: .all)
            .onAppear {
                updateBackgroundOnAppear()
            }
            .onChange(of: colorScheme, perform: { value in
                updateBackgroundColor()
            })
    }
    
    /// DogSwitcher, PredictionGallery, WeatherView, BathroomGraph
    func mainBody() -> some View {
        VStack {
            if let favoriteDog = Binding($selectedDog) {
                
                 VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        HStack {
                            HStack {
                                Text(selectedDogName).font(.title)
                                    .padding(.bottom)
                                    .padding(.leading)
                                Spacer()
                            }
                            DogSwitcher(selectedDog: favoriteDog, image: selectedDogImage)
                                .animation(.default)
                        }
                        VStack(alignment: .leading) {
                            PredictionGallery(selectedDog: favoriteDog)
                                .padding()
                            WeatherView()
                                .padding()
                            BathroomUsageGraph(selectedDog: favoriteDog)
                                .padding()
                        }
                        
                    }
                }
            }
        }
    }
    
    /// The successfully loaded content view
    func statisticViewBody() -> some View {
        ZStack {
            background()
            mainBody()
        }
        .onChange(of: selectedDog) { (_) in
            onChangeOfSelectedDog()
        }
        
    }
    
}

// Methods
@available(iOS 14.0, *)
extension StatisticsView {
    
    /// Update dog name, dog image, and set selectedDog as favorite
    func onChangeOfSelectedDog() {
        guard let favoriteDog = selectedDog else { return }
        if let dogName = favoriteDog.name {
            selectedDogName = dogName
        }
        dogs.updateFavorite(dog: favoriteDog, in: dogs.allDogs)
        if let dogImage = favoriteDog.convertImage() {
            withAnimation {
                self.selectedDogImage = dogImage
            }
        }
    }
    
    /// Update the background color on switch of nightmode
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
    
    /// Set background color depending on night mode on appear
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
    
    /// Set properties on appear - selected dog, dog name, convert favorite dog image
    func updatePropertiesOnAppear() {
        guard let dog = dogs.fetchFavoriteDog() else { return }
        selectedDog = dog
        guard let dogName = selectedDog?.name else { return }
        selectedDogName = dogName
        
        if dogs.allDogs.count == 0 {
            dogs.fetchAll()
        }
        
        guard let image = selectedDog?.convertImage() else { return }
        withAnimation {
            self.selectedDogImage = image
        }
        
    }
}


enum StatisticsViewState {
    case isLoading // App launched & fetching favorite dog
    case finishedLoading // Load Prediction & bathroom graph

    
}
