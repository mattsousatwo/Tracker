//
//  MainView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/13/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    /// Current Selected Tab
    @State private var currentTag = 0
    
    /// Dog currently being used
    @State private var favoriteDog : Dog? = nil
    
    /// Bools to handle the presentation of create new dog view
    @State private var createNewDogIsPresented: Bool = false
    @State private var createNewDogIsDismissed: Bool = false
    
    /// Bool to present an alert to tell the user that there arent any dogs created
    @State private var zeroDogsAlert: Bool = false
    
    
    @State private var initialDogHasBeenCreated: Bool = false
    
    
    /// Breeds Class
    var breeds = Breeds()
    /// Dogs Class
    @ObservedObject var dogs = Dogs()
    
    
    
    func tabView() -> some View {
        TabView(selection: self.$currentTag) {
            //                NavigationView {
            StatisticsView()
            //                        .navigationBarTitle(Text("Bathroom Break!"), displayMode: .large)
            //                }
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("Today")
                }
                .tag(0)
            
            NavigationView {
                EntryView()
            }   .tabItem {
                Image(systemName: "plus")
                Text("Add")
            }
            .tag(1)
            
            
            NavigationView {
                SettingsView()
                
            }   .tabItem{
                Text("Settings")
                Image(systemName: "gear")
            }
            .tag(2)
        }
    }
    
    
    func noDogsHaveBeenCreated() -> some View {
        NavigationView {
            if #available(iOS 14.0, *) {
                VStack(alignment: .center) {
                    Spacer()
                    
                    HStack(alignment: .center) {
                        
                        VStack {
                            Text("Welcome")
                            NavigationLink(isActive: $zeroDogsAlert) {
                                DogEntryView(isPresented: $createNewDogIsPresented,
                                             didDismiss: $createNewDogIsDismissed)
                            } label: {
                                Text("Create New Dog")
                            }
                            
                        }
                        
                        
                    }
                    
                    Spacer()
                }
                .onChange(of: dogs.allDogs) { newValue in
                    if initialDogHasBeenCreated == false {
                        initialDogHasBeenCreated = true
                    }
                }
            }
        }
    }
    
    var body: some View {
        switch zeroDogsAlert {
        case false:
            tabView()
            
                .onAppear {
                    breeds.initalizeDogBreedList()
                    
                    //                dogs.deleteAll(.dog)
                    if let favoriteDog = dogs.getFavoriteDog() {
                        self.favoriteDog = favoriteDog
                    } else {
                        //                    self.createNewDogIsPresented = true
                        self.zeroDogsAlert = true
                    }
                    
                }
        case true:
            
            
            switch initialDogHasBeenCreated {
            case true:
                tabView()
                    .animation(.default)
            case false:
                noDogsHaveBeenCreated()
                    .animation(.default)
            }
                
            
            
            
            
            
            
        }

        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
//
//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
