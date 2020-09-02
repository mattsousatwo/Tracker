//
//  MainView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/13/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct MainView: View {
    

    var body: some View {
        TabView {
            StatisticsView() 
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("History")
            }
            
            BathroomEntryView() 
            .tabItem {
                Image(systemName: "globe")
                Text("Add")
            }
            
            
            
            SettingsView()
                .tabItem{
                    Text("Settings")
                    Image(systemName: "gear")
                }
            
        
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
