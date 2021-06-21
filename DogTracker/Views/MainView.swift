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
            NavigationView {
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
                .navigationBarTitle(Text("Bathroom Break!"), displayMode: .large)
            

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
