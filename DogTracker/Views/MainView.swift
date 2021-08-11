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
    
    @State private var createNewDogIsPresented: Bool = false
    
    var breeds = Breeds()
    
    @ObservedObject var dogs = Dogs()
    
    var body: some View {
        
        if createNewDogIsPresented == false {
            
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
            
            

            
            .onAppear {
                breeds.initalizeDogBreedList()
                
   
                if let favoriteDog = dogs.getFavoriteDog() {
                    self.favoriteDog = favoriteDog
                } else {
                    self.createNewDogIsPresented = true
                }
                
            }
            
            
            
            
        } else {
            HStack {
                Spacer()
                Button("No Dogs Created") {
                    
                }.sheet(isPresented: $createNewDogIsPresented) {
                    DogEntryView(isPresented: $createNewDogIsPresented, didDismiss: .constant(false))
                }
                
                Spacer()
                
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
