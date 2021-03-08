//
//  DogEntryView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct DogEntryView: View {
    
    @State private var name: String = ""
    @State private var weight: String = ""
    
    /// Return save button
    private func saveButton() -> some View {
        let button = Button("Save") {
            print("NewDogSaved - ")
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color.blue)
        .foregroundColor(Color.white)
        .font(.headline)
        .cornerRadius(15)
        .shadow(radius: 2)
        return button
    }
    
    var body: some View {
        Form {
            TextField("Name:", text: $name)
                .padding()
            
            Text("Breed")
            // add picker for each breed type
            
            
            Section {
                // Date Picker for Birthday
                Text("Birthday")
                TextField("Weight: ", text: $weight).keyboardType(.decimalPad)
                
            }
            
            saveButton()
        }
        .navigationBarTitle(Text("New Dog"))
    }
}

struct DogEntryView_Previews: PreviewProvider {
    static var previews: some View {
        DogEntryView()
    }
}
