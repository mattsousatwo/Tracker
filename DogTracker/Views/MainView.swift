//
//  MainView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/13/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @State private var currentTag = 0
    
    @State private var favoriteDog: Dog = Dog()
    
    var breeds = Breeds()
    
    
    var body: some View {
        
        TabView(selection: self.$currentTag) {
            
            StatisticsView() 
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("History")
                }
                .tag(0)
            
            BathroomEntryView(favorite: $favoriteDog) 
                .tabItem {
                    Image(systemName: "globe")
                    Text("Add")
                }
                .tag(1)
 
            SettingsView()
                .tabItem{
                    Text("Settings")
                    Image(systemName: "gear")
                }
                .tag(2)
            }
            
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(Text("Bathroom Break!"), displayMode: .inline)
        
        .onAppear {
            breeds.initalizeDogBreedList()
            
            
            let dogs = Dogs()
            if let favoriteDog = dogs.getFavoriteDog() {
                self.favoriteDog = favoriteDog
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
