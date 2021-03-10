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
    
    var body: some View {
        
        List {
            
            ForEach(breeds.allBreeds, id: \.self) { breed in
                if let name = breed.name {
                    Button {
                        self.isPresented = false
                        selectedBreed = name
                    } label: {
                        Text(name)
                            .padding()
                            .font(.body)
                            .foregroundColor(.black)
                    }

                }
                 
                
            }
        
        }
        .onAppear {
            breeds.fetchAll()
            print("All Breeds Count: \(breeds.allBreeds.count)")
        }
        
        
    }
}



struct SelectDogBreedList_Previews: PreviewProvider {
    static var previews: some View {
        SelectDogBreedList(isPresented: .constant(true), selectedBreed: .constant(""))
    }
}
