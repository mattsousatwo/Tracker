//
//  DogEntryView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

/// Titles for each property in DogEntryView
private enum DogEntryScript: String {
    case emptyString = ""
    case defaultBreedString = "Select Breed:"
    case name = "Name:"
    case birthdate = "Birthdate:"
    case weight = "Weight:"
    case setFavorite = "Set as favorite"
    
}

/// Type to contain states of access for dog properties
enum SaveDogState {
    case accepted, denied, standard
}


struct DogEntryView: View {
    
    
    // MARK: TO DO -
    // Convert Weight to Double
    // Convert Date to accepted date
    
    
    
    @Binding var isPresented: Bool
    @Binding var didDismiss: Bool
    
    @State private var acceptNewDogState: SaveDogState = .standard
    @State private var buttonColor: Color = .gray
    @State private var saveWasPressed: Bool = false
        
    @State private var name: String = DogEntryScript.emptyString.rawValue
    @State private var weight: String = DogEntryScript.emptyString.rawValue
    @State private var birthdate: String = DogEntryScript.emptyString.rawValue
    @State private var isFavorite: Bool = false
    
    
    @State private var presentSelectBreedList: Bool = false
    @State private var selectedDogBreed: String = DogEntryScript.defaultBreedString.rawValue
    
    let dogs = Dogs()
    
    /// Look through dog properties to see if new dog can be created || if so enable save else disable save
    private func updateNewDogState() {
        if name != DogEntryScript.emptyString.rawValue,
           weight != DogEntryScript.emptyString.rawValue,
           birthdate != DogEntryScript.emptyString.rawValue,
           selectedDogBreed != DogEntryScript.defaultBreedString.rawValue {

            acceptNewDogState = .accepted
            buttonColor = .blue
        } else {
            if saveWasPressed == true {
                acceptNewDogState = .denied
                buttonColor = .red
            } else {
                acceptNewDogState = .standard
                buttonColor = .gray
            }
        }
    }
    
    
    
    
    /// Return save button
    private func saveButton() -> some View {
        let button = Button("Save") {
            
            saveWasPressed = true
            
            if acceptNewDogState == .accepted {
                // Dismiss View
                isPresented = false
                didDismiss = true 
            }
            
            updateNewDogState()
            
            
            // https://swiftwithmajid.com/2020/05/06/building-calendar-without-uicollectionview-in-swiftui/
            
            
            
            // Save
            if acceptNewDogState == .accepted {
                let _ = dogs.createNewDog(name: name,
                                          breed: selectedDogBreed,
                                          birthdate: birthdate,
                                          isFavorite: isFavorite)
            } else {
                buttonColor = .red
                    
            }
            
            
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(buttonColor)
        .foregroundColor(Color.white)
        .font(.headline)
        .cornerRadius(15)
        .shadow(radius: 2)
        .animation(.default)
        return button
    }
    
    var body: some View {

        if #available(iOS 14.0, *) {
            Form {
                // MARK: Name
                TextField(DogEntryScript.name.rawValue,
                          text: $name)
                    .onChange(of: name, perform: { _ in
                        updateNewDogState()
                    })
                    .padding()
                
                // MARK: Select Breed
                Button {
                    self.presentSelectBreedList.toggle()
                } label: {
                    if selectedDogBreed == DogEntryScript.defaultBreedString.rawValue {
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
                                       selectedBreed: $selectedDogBreed)
                }
                .onChange(of: selectedDogBreed, perform: { _ in
                    updateNewDogState()
                })
                
                
                Section {
                    // MARK: Birthday
                    TextField(DogEntryScript.birthdate.rawValue, text: $birthdate)
                        .padding()
                        .keyboardType(.numbersAndPunctuation)
                        .onChange(of: birthdate, perform: { _ in
                            updateNewDogState()
                        })
                    
                    // MARK: Weight
                    TextField(DogEntryScript.weight.rawValue, text: $weight)
                        .padding()
                        .keyboardType(.decimalPad)
                        .onChange(of: weight, perform: { _ in
                            updateNewDogState()
                        })
                }
                
                Section {
                    // MARK: Set Favorite
                    ToggleRow(title: DogEntryScript.setFavorite.rawValue,
                              isOn: $isFavorite)
                        .font(.body)
                        .padding()
                }
                
                saveButton()
            }
            .navigationBarTitle(Text("New Dog"))
        }
        
        
        
        
    }
}

struct DogEntryView_Previews: PreviewProvider {
    static var previews: some View {
        DogEntryView(isPresented: .constant(true ), didDismiss: .constant(false))
    }
}
