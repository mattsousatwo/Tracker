//
//  DogsForm.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct DogsList: View {
    
    let dogs = Dogs()
    @State private var newDogEntryIsActive: Bool = false
    
    /// Button to add new Dog name to dogs array
    func addNewDogButton() -> some View {
        let button = Button(action: {
            self.newDogEntryIsActive.toggle()
        }) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .light, design: .rounded))
                .padding()
        }.sheet(isPresented: $newDogEntryIsActive) {
            DogEntryView()
        }
        return button
    }
    
    /// Container of dogs (as Strings)
    var dogArray: [Dog] {
        
        var allDogs: [Dog] = []
        
        dogs.fetchAll()
        if let dogsInCD = dogs.allDogs {
            return dogsInCD
        } else if dogs.allDogs?.count == 0 {
            if let dog = dogs.createNewDog(name: "Bandit", breed: "Terrier") {
                allDogs.append(dog)
            }
        }
        return allDogs
    }
    
    var body: some View {
        List {
            ForEach(dogArray, id: \.self) { dog in
                NavigationLink(destination: DogDetail() ) {
                    if dog.name == "Tito" {
                        DogRow(dog: dog,
                               isFavorite: true)
                    } else {
                        DogRow(dog: dog)
                    }
                    
                }
            }
        }
        .navigationBarItems(trailing: addNewDogButton() )
    }
    
    
}

struct DogsList_Previews: PreviewProvider {
    static var previews: some View {
        DogsList()
    }
}
