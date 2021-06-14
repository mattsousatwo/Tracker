//
//  DogDetail.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct DogDetail: View {
    
    let dog: Dog?
    
    @State private var acceptNewDogState: SaveDogState = .standard
    @State private var buttonColor: Color = .gray
    @State private var saveWasPressed: Bool = false
    
    @State private var name: String = DogEntryScript.emptyString.rawValue
    @State private var weight: String = DogEntryScript.emptyString.rawValue
    @State private var birthdate: String = DogEntryScript.emptyString.rawValue
    @State private var isFavorite: Bool = false
    
    @State private var presentSelectBreedList: Bool = false
    @State private var selectedDogBreed: String = DogEntryScript.defaultBreedString.rawValue
    
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

    private func hasChanges() -> Bool {
        if name != dog?.name {
            return true
        }
        if weight != "\(String(describing: dog?.weight))" {
            return true
        }
        
        if birthdate != dog?.birthdate {
            return true
        }
        
        var favorite: Int16 {
            if isFavorite == true {
                return 1
            } else {
                return 0
            }
        }
        
        if favorite != dog?.isFavorite {
            return true
        }
        
        return false
    }
    
    private func updateButton() -> some View {
        let button = Button("Update") {
            saveWasPressed = true
            updateNewDogState()
            
            if acceptNewDogState == .accepted {

                dog?.update()

            } else {
                buttonColor = .red
            }
        
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(buttonColor)
        .foregroundColor(.white)
        .font(.headline)
        .cornerRadius(15)
        .shadow(radius: 2)
        .animation(.default)
        return button
        
    }
    
    var breeds: [String] {
        var breedList: [String] = []
        if let savedBreeds = dog?.decodeBreeds() {
            breedList = savedBreeds
        }
        return breedList
    }
    
    
    var body: some View {
        Form {
            if #available(iOS 14.0, *) {
                TextField(dog?.name ?? name, text: $name)
                    .onChange(of: name) { _ in
                        updateNewDogState()
                    }
                    .padding()
                
                Section {
                    
                    HStack {
                        
                        Text("Breed")
                            .padding()
                        
                        Spacer()
                        
                        Button {
                            self.presentSelectBreedList.toggle()
                        } label: {
                            Icon(image: "plus", color: .green)
                                .frame(width: 20, height: 20)
                                .padding()
                        }.sheet(isPresented: $presentSelectBreedList) {
                            SelectDogBreedList(isPresented: $presentSelectBreedList,
                                               selectedBreed: $selectedDogBreed)
                        }
                        .onChange(of: selectedDogBreed, perform: { _ in
                            updateNewDogState()
                        })
                    }
                    
                    ForEach(breeds, id: \.self) { breed in
                        Text(breed)
                            .padding()
                    }
                    
                    
                }
                    
                
                Section {
                    TextField(dog?.birthdate ?? birthdate, text: $birthdate)
                        .padding()
                        .keyboardType(.numbersAndPunctuation)
                        .onChange(of: birthdate, perform: { _ in
                            updateNewDogState()
                        })
                    TextField(weight, text: $weight)
                        .padding()
                        .keyboardType(.decimalPad)
                        .onChange(of: weight, perform: { _ in
                            updateNewDogState()
                        })
                    
                    ToggleRow(title: DogEntryScript.setFavorite.rawValue, isOn: $isFavorite)
                        .font(.body)
                        .padding()
                }
                updateButton()
                
                
                
                
                
            } else {
                // Fallback on earlier versions
            }
            
            
        
        }
        .onAppear {
            if let dog = dog {
                if let name = dog.name {
                    self.name = name
                }
                
                self.weight = "\(dog.weight)"
                
                if let birthday = dog.birthdate {
                    self.birthdate = birthday
                }
                
                if dog.isFavorite == DogFavoriteKey.isFavorite.rawValue {
                    self.isFavorite = true
                } else {
                    self.isFavorite = false
                }
                
                if let breed = dog.breed {
                    self.selectedDogBreed = breed
                }
            }
        }
        
    }
}

struct DogDetail_Previews: PreviewProvider {
    static var previews: some View {
        DogDetail(dog: nil)
    }
}
