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
    var bathroomTypes = ["Pee", "Poop", "Vomit"]
    @State private var notes = ""
    @State private var b = false
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    EntryRow(label: "bathroomType", bathroomTypes: bathroomTypes)
                    
                    EntryRow(label: "second", bathroomTypes: ["something", "else"])
                }
                
                Section {
                    TimeRow()
                    
                    
                }
                
                Section {
                    TextField("Notes", text: $notes)
                }
                
                Button(action: {
                    self.b.toggle()
                }) {
                Text("Save")
       
                    
                    
                    .padding()
//          .frame(width: 200, height: 45, alignment: .center)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 20))
                    .cornerRadius(15)
                                    
                }
                .sheet(isPresented: $b) {
                    SwiftUIView()
                }
                
                
                
                
            }
            .navigationBarTitle(Text("Bathroom"))
        
            
        
        }
    
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    
    }
}
