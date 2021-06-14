//
//  DogsForm.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct DogsList: View {
    
    @ObservedObject var dogs = Dogs()
    @State private var newDogEntryIsActive: Bool = false
    @State private var newDogEntryWasDismissed: Bool = false
    
    /// Button to add new Dog name to dogs array
    func addNewDogButton() -> some View {
        let button = Button(action: {
            self.newDogEntryIsActive.toggle()
        }) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .light, design: .rounded))
                .padding()
        }.sheet(isPresented: $newDogEntryIsActive) {
            DogEntryView(isPresented: $newDogEntryIsActive, didDismiss: $newDogEntryWasDismissed)
        }
        return button
    }
    
    
    @State private var dogContainer: [Dog] = []
    
    var body: some View {
        
        if #available(iOS 14.0, *) {
            List {
                //                ForEach(dogContainer, id: \.self) { dog in
                ForEach(dogs.allDogs, id: \.self) { dog in
                    NavigationLink(destination: DogDetail(dog: dog) ) {
                        
                        DogRow(dog: dog)
                        
                        
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationBarItems(trailing: addNewDogButton() )
            
            .onAppear {
                dogs.fetchAll()
                //                dogContainer = dogs.allDogs
            }
            .onChange(of: newDogEntryWasDismissed) { _ in
                reloadDogs()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    // DogEntryView is dismissed and then this method is called to reload all dogs
    func reloadDogs() {
        newDogEntryWasDismissed = false
        dogs.fetchAll()
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach({ index in
//            print("Delete at \(index): dog - \(dogContainer[index] )")
//            let dogID = dogContainer[index].uuid
            let dogID = dogs.allDogs[index].uuid
            
//            dogContainer.remove(at: index)
            
            dogs.allDogs.removeAll(where: { $0.uuid == dogID })
            dogs.deleteSpecificElement(.dog, id: dogID)
            
        })
    }
    
}

struct DogsList_Previews: PreviewProvider {
    static var previews: some View {
        DogsList()
    }
}
