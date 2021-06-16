//
//  SelectDogBreedList.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/9/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct SelectDogBreedList: View {
    
    @Binding var isPresented: Bool
    @Binding var selectedBreed: [String]
    
    @ObservedObject var breeds = Breeds()
    
    @State var selectedBreeds: [Breed] = []
    @State var workingBreeds: [BreedKey] = []
    
    /// Add or remove breed from selectedBreeds
    func updateSelection(_ breed: Breed) {
            if selectedBreeds.contains(breed) {
                selectedBreeds.removeAll(where: {$0 == breed })
            } else {
                selectedBreeds.append(breed)
            }
        print("\(selectedBreeds)")
    }
    
    /// Change selected breeds in workingBreeds to false - changing the color of selected rows
    func clearSelectedBreeds() {
        if workingBreeds.count != 0 {
            for breed in workingBreeds {
                if breed.isSelected == true {
                    breed.isSelected = false
                }
            }
        }
    }
    
    var body: some View {
        HStack {
            Button {
                
                self.selectedBreeds.removeAll()
                clearSelectedBreeds()
                print("selected breed count: \(selectedBreeds.count)")
                
            } label: {
                Text("Deselect All")
                    .padding()
            }
            
            Spacer()
            
            Button {
                
                // Convert Breed String array by using dogs.encode(breeds)
                for breed in selectedBreeds {
                    if let name = breed.name {
                        self.selectedBreed.append(name)
                    }
                }
                isPresented = false
            } label: {
                Text("Done")
                    .padding()
            }
        }
        
        List {
            ForEach(0..<workingBreeds.count, id: \.self) { index in
                let breed = workingBreeds[index].breed
                if let name = breed.name {
                    Button {
                        
//                        self.selectedBreeds.append(breed)
                        updateSelection(breed)
                        
                        
                        workingBreeds[index].toggleSelection()
                        
                    } label: {
                        if #available(iOS 14.0, *) {
                            Text(name)
                                .textCase(.none)
                                .padding()
                                .font(.body)
                                .foregroundColor(workingBreeds[index].isSelected ? .blue : .black)
                                .animation(.default)
                        } else {
                            Text(name)
                                .padding()
                                .font(.body)
                                .foregroundColor(workingBreeds[index].isSelected ? .blue : .black)
                                .animation(.default)
                        }
                    }
                    .animation(.default, value: selectedBreeds)

                }
                 
                
            }
        
        }
        
        .onAppear {
            breeds.fetchAll()
            print("All Breeds Count: \(breeds.allBreeds.count)")
        }
        
        .onReceive(breeds.$allBreeds, perform: { _ in
            print("Recieved breeds")
            if breeds.allBreeds.count != 0 {
                for breed in breeds.allBreeds {
                    let newBreed = BreedKey(breed: breed,
                                            isSelected: false)
                    workingBreeds.append(newBreed)
                }
            }
            
        })
        
    }
}



struct SelectDogBreedList_Previews: PreviewProvider {
    static var previews: some View {
        SelectDogBreedList(isPresented: .constant(true), selectedBreed: .constant([""]))
    }
}


class BreedKey {
    
    var breed: Breed
    var isSelected: Bool
    
    var color: Color {
        if isSelected == true {
            return .blue
        } else {
            return .black
        }
    }

    init(breed: Breed, isSelected: Bool) {
        self.breed = breed
        self.isSelected = isSelected
    }

    func toggleSelection() {
        if self.isSelected == true {
            isSelected = false
        } else {
            if self.isSelected == false {
                isSelected = true
            }
        }
    }
}
