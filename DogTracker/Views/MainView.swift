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
    
    
    /// Breeds Class
    var breeds = Breeds()
    /// Dogs Class 
    @ObservedObject var dogs = Dogs()
    
    var body: some View {
        
        if zeroDogsAlert == false {
            
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
            
//            .alert(isPresented: $zeroDogsAlert,
//                   content: {
//
//                Alert(title: Text("Bathroom Break"),
//                      message: Text("There are zero dogs found."),
//                      dismissButton:  .default(Text("Create new dog"),
//                                               action: {
//                    createNewDogIsPresented = true
//                }))
//
//            })

            
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
            
        } else {
            
            
            
            
            
            
            
            
            
            NavigationView {
            
            HStack {
                Spacer()
                
                NavigationLink(isActive: $createNewDogIsPresented) {
                    DogEntryView(isPresented: $createNewDogIsPresented,
                                 didDismiss: $createNewDogIsDismissed)
                } label: {
                    Text("Create new dog")
                }

                
//                Button("No Dogs Created") {
//
//                }
//                .sheet(isPresented: $createNewDogIsPresented) {
//                    DogEntryView(isPresented: $createNewDogIsPresented, didDismiss: .constant(false))
//                }

            .alert(isPresented: $zeroDogsAlert,
                   content: {

                Alert(title: Text("Bathroom Break"),
                      message: Text("There are zero dogs found."),
                      dismissButton:  .default(Text("Create new dog"),
                                               action: {

                    createNewDogIsPresented = true
                })  )
            })



                Spacer()
            }
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
