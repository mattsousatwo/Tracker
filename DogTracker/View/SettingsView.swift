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
    @State private var showExtras: Int = 0
    // Toggle notifications
    @State private var enableNotifications: Int = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // Display Extra parameters when adding bathroom entry
                    BoolSegmentRow(bindingType: $showExtras, label: "Show Extras", option1: "Yes", option2: "No")
                    // Toggle notifications
                    BoolSegmentRow(bindingType: $enableNotifications, label: "Notifications", option1: "Enable", option2: "Disable")
                }
                    
                Section {
                    Text("Thank you for using BathroomBreak!")
                        
                }
                .navigationBarTitle(Text("Settings").font(.largeTitle) )
            }
            
        } // NavigationView
    } // Body
} // SettingsView

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

