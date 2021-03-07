//
//  DogsForm.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct DogsList: View {
    
    /// Button to add new Dog name to dogs array
    func addNewDogButton() -> some View {
        let button = Button(action: {
            self.dogs.append("Fido")
        }) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .light, design: .rounded))
                .padding()
        }
        return button
    }
    
    /// Container of dogs (as Strings)
    @State var dogs = ["Tito", "Rosie", "Bandit", "Tessa"]
    
    var body: some View { 

        List {
            ForEach(dogs, id: \.self) { dog in
                NavigationLink(destination: DogDetail() ) {
                    Text(dog).padding()
                }
            }
        }
        .navigationBarItems(trailing:
            addNewDogButton()
        )
    }
    
    
}

struct DogsList_Previews: PreviewProvider {
    static var previews: some View {
        DogsList()
    }
}
