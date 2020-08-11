//
//  ContentView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/10/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let x = BathroomBreak()
    @State private var favoriteColor = 0
    var colors = ["Pee", "Poop", "Vomit"]
    
    var body: some View {
        NavigationView {
            Form {
                EntryRow(label: "bathroomType", bathroomTypes: colors)
                        
                    

            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    
    }
}
