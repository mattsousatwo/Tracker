//
//  SettingsView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/21/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

@available(iOS 15.0, *)
struct SettingsView: View {
    // Display Extra Parameters for bathroom entries
    @State private var showExtras: Bool = false
    // Toggle notifications
    @State private var enableNotifications: Bool = false
    
    
    
    @State private var favoriteFood: Food? = nil 
    @State private var foodSelectionListIsPresented: Bool = false
    
    
    @ObservedObject var userDefaults = UserDefaults()
    
    
    var body: some View {
        
        Form {
            
            Section {
                
                NavigationLink(destination: DogsList() ) {
                    
                    HStack {
                        Icon(image: "square.fill.text.grid.1x2",
                             color: .lightBlue)
                            .padding(5)
                        
                        Text("Dog List")
                    }
                }
                
            }
            
            Section {
                
                
                NavigationLink(destination: AllFoodsList() ) {
                    
                    HStack {
                        Icon(image: "list.dash",
                             color: .lightBlue)
                            .padding(5)
                        
                        Text("Food List")
                    }
                }
                
            }
            
                
            Section {
                
                ForEach(0..<userDefaults.settings.count, id: \.self) { i in
                    if let setting = userDefaults.detectTag(for: userDefaults.settings[i]) {
                        let credentials = setting.rowCredentials()
//                        if let value = userDefaults.getValue(from: userDefaults.settings[i]) {
                            
                            ToggleRow(icon: credentials.icon,
                                      color: credentials.color,
                                      title: credentials.title,
                                      isOn: nil,
                                      setting: userDefaults.settings[i])
                            
//                        }
                    }
                }
                
                
            }
            
            
            Section {
                
                NavigationLink(destination: StatisticsBarSettingsView() ) {
                    
                    HStack {
                        Icon(image: "directcurrent",
                             color: .lightBlue)
                            .padding(5)
                        
                        Text("Statistics Bar")
                    }
                }
                
            }
            
            
            

                    
            Section {
                Text("Thank you for using BathroomBreak!")
                    .padding()
                        
            }
            
        }
        .navigationBarTitle(Text("Settings") )
        .onAppear {
            userDefaults.initalizeUserDefaults()
        }
        
    } // Body
} // SettingsView


