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
    @State private var birthdate: String = ""
    @State private var isFavorite: Bool = false
    
    
    @State private var presentSelectBreedList: Bool = false
    @State private var selectedDogBreed: String = "Select Breed:"
    
    let dogs = Dogs()
    
    /// Return save button
    private func saveButton() -> some View {
        let button = Button("Save") {
            
            
            // MARK: TO DO -
            // Convert Weight to Double
            // Convert Date to accepted date
            // create func to return a newDog w| uuid, then set each property if meet requirements
            
            let _ = dogs.createNewDog(name: name,
                              breed: selectedDogBreed,
                              birthdate: birthdate,
                              isFavorite: isFavorite)
            
            
            
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
            
            Button {
                self.presentSelectBreedList.toggle()
            } label: {
                if selectedDogBreed == "Select Breed:" {
                    Text(selectedDogBreed)
                        .padding()
                        .foregroundColor(.gray)
                } else {
                    Text(selectedDogBreed)
                        .padding()
                        .foregroundColor(.black)
                }
                
                
            }.sheet(isPresented: $presentSelectBreedList) {
                    SelectDogBreedList(isPresented: $presentSelectBreedList,
                                        selectedBreed: $selectedDogBreed) }
    
            
            Section {
                    TextField("Birthdate:", text: $birthdate)
                        .padding()
                        .keyboardType(.numbersAndPunctuation)
             
                TextField("Weight: ", text: $weight)
                    .padding()
                    .keyboardType(.decimalPad)
            }
            
            Section {
                ToggleRow(title: "Set as favorite",
                          isOn: $isFavorite)
                    .font(.body)
                    .padding()
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
