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
    
    

    var body: some View {
        TabView(selection: self.$currentTag) {
            
            StatisticsView() 
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("History")
                }
                .tag(0)
            
            BathroomEntryView() 
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
            let formatter = DateFormatter()
            
            let date = formatter.dateFormat(Date() )
            let time = formatter.timeFormat(Date() )
            
            print("\nDate: \(date)")
            print("Time: \(time)\n")
        }
    
        
    }

}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
