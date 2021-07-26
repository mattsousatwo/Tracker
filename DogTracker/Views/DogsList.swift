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
    func newDogSegue() -> some View {
        let button = Button(action: {
            self.newDogEntryIsActive.toggle()
        }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .light, design: .rounded))
                    .padding()
            
        }.sheet(isPresented: $newDogEntryIsActive) {
            DogEntryView(isPresented: $newDogEntryIsActive,
                         didDismiss: $newDogEntryWasDismissed)
        }
        return button
    }
    
    func navLink(dog key: DogKey) -> some View {
        print("dog: \(key.dog.name ?? ""), fav: \(key.isFavorite)")
        return NavigationLink(destination:
                                
                                ProfileView(selectedDog: key.dog)
                                
//                                DogEntryView(isPresented: $newDogEntryIsActive,
//                                             didDismiss: $newDogEntryWasDismissed,
//                                             selectedDog: key.dog)
        ) {
            Text(key.dog.name ?? "")
                .foregroundColor(key.isFavorite ? .blue : .none)
                .padding()
        }
        
    }
    
    func newNavLink(dog key: DogKey) -> some View {
        print("dog: \(key.dog.name ?? ""), fav: \(key.isFavorite)")
        let button = Button(action: {
            self.newDogEntryIsActive.toggle()
        }) {
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.main.bounds.width - 20,
                       height: 60,
                       alignment: .leading)
                .foregroundColor(.clear)
                .overlay(
                    Text(key.dog.name ?? "")
                        .foregroundColor(key.isFavorite ? .blue : .none)
                        .padding()
                    , alignment: .leading)
            
        }.sheet(isPresented: $newDogEntryIsActive) {
            DogEntryView(isPresented: $newDogEntryIsActive,
                         didDismiss: $newDogEntryWasDismissed,
                         selectedDog: key.dog)
        }
        return button
    }

    
    @State private var workingDogs: [DogKey] = []
    @State private var dogContainer: [Dog] = []
    
    var body: some View {
        
        if #available(iOS 14.0, *) {
            List {
//                                ForEach(dogContainer, id: \.self) { dog in
//                ForEach(dogs.allDogs, id: \.self) { dog in
                ForEach(0..<workingDogs.count, id: \.self) { i in
                    let key = workingDogs[i]
                        navLink(dog: workingDogs[i])
  
                }
                .onDelete(perform: delete)
                
            }
            
            .padding(.top)
            .navigationBarTitle(Text("Dog List"), displayMode: .inline)
            .navigationBarItems(trailing: newDogSegue() )
            
            .onAppear {
                dogs.fetchAll()
            }
            .onReceive(dogs.$allDogs, perform: { (allDogs) in
                workingDogs.removeAll()
                for dog in allDogs {
                    var isFavorite: Bool {
                        if dog.isFavorite == 1 {
                            return true
                        } else {
                            return false
                        }
                    }
                    let dogKey = DogKey(dog: dog, isFavorite: isFavorite)
                    workingDogs.append(dogKey)
                }
            })
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
//            let dogID = dogs.allDogs[index].uuid
            
            let dogID = workingDogs[index].dog.uuid
            
            
            if workingDogs[index].dog.isFavorite == 1 {
                updateFavoriteSelection(index: index)
            }
            workingDogs.remove(at: index)
            
            
            
//            dogContainer.remove(at: index)
            
            dogs.allDogs.removeAll(where: { $0.uuid == dogID })
            dogs.deleteSpecificElement(.dog, id: dogID)
            
        })
    }
    
    func updateFavoriteSelection(index: Int) {
        switch index {
        case 0:
            if workingDogs.count == 0 {
                self.newDogEntryIsActive.toggle()
            } else if workingDogs.count >= 0 {
                workingDogs[index + 1].dog.update(isFavorite: .isFavorite)
            }
        case workingDogs.count - 1:
            workingDogs[index - 1].dog.update(isFavorite: .isFavorite)
        default:
            if workingDogs.count == index - 1 {
                workingDogs[index - 1].dog.update(isFavorite: .isFavorite)
            } else if workingDogs.count != index + 1 {
                workingDogs[index + 1].dog.update(isFavorite: .isFavorite)
                
            }
        }
    }
    
    
}

struct DogsList_Previews: PreviewProvider {
    static var previews: some View {
        DogsList()
    }
}

class DogKey {
    let dog: Dog
    var isFavorite: Bool
    
    init(dog: Dog, isFavorite: Bool) {
        self.dog = dog
        self.isFavorite = isFavorite
    }
    
    func toggleFavorite() {
        self.isFavorite.toggle()
    }
}
