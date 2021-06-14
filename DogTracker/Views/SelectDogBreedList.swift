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
    @Binding var selectedBreed: String
    
    @ObservedObject var breeds = Breeds()
    
    
    @State var selectedBreeds: [Breed] = []
    @State var allBreeds: [Breed] = []
    
    func isBreedSelected() -> Bool {
        for breed in allBreeds {
            for selectedBreed in selectedBreeds {
                if selectedBreed == breed {
                    print("isBreedSelected: True")
                    return true
                } else {
                    print("isBreedSelected: False")
                    return false
                }
            }
        }
        return false
    }
    
    func updateSelection(_ breed: Breed) {
        if selectedBreeds.count != 0 {
            if selectedBreeds.contains(breed) {
                selectedBreeds.removeAll(where: {$0 == breed })
            } else {
                selectedBreeds.append(breed)
            }
        }
    }
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Text("Deselect All")
                    .padding()
            }
            
            Spacer()
            
            Button {
                
                // Convert Breed String array by using dogs.encode(breeds)
                
                
            } label: {
                Text("Done")
                    .padding()
                    
                
            }
        }
        
        List {
            
            ForEach(allBreeds, id: \.self) { breed in
                if let name = breed.name {
                    Button {
                        
//                        self.selectedBreeds.append(breed)
                        updateSelection(breed)
                    } label: {
                        Text(name)
                            .padding()
                            .font(.body)
                            .foregroundColor(isBreedSelected() ? .blue: .black)
                            .animation(.default)
                    }

                }
                 
                
            }
        
        }
        
        .onAppear {
            breeds.fetchAll()
            print("All Breeds Count: \(breeds.allBreeds.count)")
        }
        
        .onReceive(breeds.$allBreeds, perform: { _ in
            print("Recieved breeds")
            allBreeds = breeds.allBreeds
        })
        
    }
}



struct SelectDogBreedList_Previews: PreviewProvider {
    static var previews: some View {
        SelectDogBreedList(isPresented: .constant(true), selectedBreed: .constant(""))
    }
}
