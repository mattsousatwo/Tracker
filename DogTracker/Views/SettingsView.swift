//
//  SettingsView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/21/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    // Display Extra Parameters for bathroom entries
    @State private var showExtras: Bool = false
    // Toggle notifications
    @State private var enableNotifications: Bool = false
    
    @State private var bindingBool: Bool = true
    
    
    @ObservedObject var userDefaults = UserDefaults()
    
    
    var body: some View {
        
        Form {
                
            Section(header: Text("Profile")) {
                    
                   
                NavigationLink(destination: ProfileView() ) {
                        
                    ProfileRow(profileImage: Image("Sand-Dog"),
                               name: "Title",
                               highlights: "Highlights")
                    
                        .buttonStyle(PlainButtonStyle())
                    
                        
                }

                        
            }
            
            Section {
                
                NavigationLink(destination: DogsList() ) {
                    
                    HStack {
                        Icon(image: "square.fill.text.grid.1x2",
                             color: .androidGreen)
                            .padding(5)
                        
                        Text("Dogs")
                    }
                }
                
            }
            
                
            Section {
                
                ForEach(0..<userDefaults.settings.count, id: \.self) { i in
                    if let setting = userDefaults.detectTag(for: userDefaults.settings[i]) {
                        let credentials = setting.rowCredentials()
                        if let value = userDefaults.getValue(from: userDefaults.settings[i]) {
                            
                            ToggleRow(icon: credentials.icon,
                                      color: credentials.color,
                                      title: credentials.title,
                                      isOn: nil,
                                      setting: userDefaults.settings[i])
                            
                        }
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

