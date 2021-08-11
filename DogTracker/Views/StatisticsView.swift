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
                            
                            
                            
                            
                            //                        Button {
                            //                            self.present.toggle()
                            //                        } label: {
                            //                            ProfileImage(selectedDog: $selectedDog, image: selectedDogImage)
                            //                        }
                            ////                        .sheet(isPresented: $present, content: {
                            //////                            HistoryView()
                            ////                            ProfileView(selectedDog: selectedDog)
                            ////                        })
                            //                        .actionSheet(isPresented: $present, content: { () -> ActionSheet in
                            //                            ActionSheet(title: Text("Select Dog"),
                            //                                        message: Text("Choose a dog to be set as a favorite"),
                            //                                        buttons: [
                            //                                            .default(Text("")) { },
                            //                                            .cancel()
                            //                                        ])
                            //                        })
                            ProfileImage(selectedDog: $selectedDog, image: selectedDogImage)
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
                                    
                                    trackerConversion.getFrequencyOfBathroomUse()
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


struct ProfileImage: View {
    
    @State private var present: Bool = false
    @State private var actionButtons: [ActionSheet.Button] = [.cancel()]
    @Binding var selectedDog: Dog
    
    var image: UIImage?
    
    var body: some View {
        
        Button {
            self.present.toggle()
        } label: {
            
            
            
            if let image = image {
                Image(uiImage: image).resizable().clipShape(Circle() )
                    .frame(width: 60, height: 60, alignment: .topLeading)
                    .padding()
                    .shadow(radius: 5)
            } else {
                Image(uiImage: UIImage(named: "Sand-Dog")!).resizable().clipShape(Circle() )
                    .frame(width: 60, height: 60, alignment: .topLeading)
                    .padding()
                    .shadow(radius: 5)
            }
            
            
        }
        //                        .sheet(isPresented: $present, content: {
        ////                            HistoryView()
        //                            ProfileView(selectedDog: selectedDog)
        //                        })
        .actionSheet(isPresented: $present, content: { () -> ActionSheet in
            ActionSheet(title: Text("Select Dog"),
                        message: Text("Choose a dog to be set as a favorite"),
                        buttons: actionButtons)
        })
        .onAppear {
            let dogs = Dogs()
            if dogs.allDogs.count == 0 {
                dogs.fetchAll()
            }
            
            
            if dogs.allDogs.count != 0 &&
                actionButtons.count == 1 {
                
                for dog in dogs.allDogs {
                    if let name = dog.name {
                        let button = ActionSheet.Button.default(Text(name)) { selectedDog = dog
                            dogs.updateFavorite(dog: selectedDog, in: dogs.allDogs)
                        }
                        actionButtons.append(button)
                    }
                }
            }
            
            
            
        }
        
        
        
        
        
        
        
        
        
    }
}
