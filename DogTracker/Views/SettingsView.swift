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
    
    var body: some View {
        
        Form {
                
            Section(header: Text("Profile")) {
                    
                   
                NavigationLink(destination: ProfileView() ) {
                        
                    ProfileRow(profileImage: Image("Sand-Dog"), name: "Title", highlights: "Highlights")
                }

                        
            }
                
            Section {
                    
                // Display Extra parameters when adding bathroom entry
                ToggleRow(icon: "aspectratio", color: Color.orange, title: "Display Extras", isOn: $showExtras)
                // Toggle notifications
                ToggleRow(icon: "bell", color: Color.blue, title: "Enable Notifications", isOn: $enableNotifications)
                
            }
                    
            Section {
                Text("Thank you for using BathroomBreak!")
                    .padding()
                        
            }
            .navigationBarTitle(Text("Settings") )
        }
            
        
    } // Body
} // SettingsView

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

