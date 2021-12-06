//
//  SelectDogList.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/7/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct SelectDogList: View {
    
    @Binding var favoriteDog: Dog?
    @Binding var isPresented: Bool
    let updateFavoriteDogOnSelection: Bool 
    
    @ObservedObject var dogs = Dogs()
    
    @State private var allDogs = [Dog]()
    
    @State private var newDogEntryIsActive: Bool = false
    @State private var newDogEntryWasDismissed: Bool = false
    
    init(dog: Binding<Dog?>, isPresented: Binding<Bool>, favoriteEditor: Bool = true) {
        self._favoriteDog = dog
        self._isPresented = isPresented
        self.updateFavoriteDogOnSelection = favoriteEditor
    }
    
    
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
    
    var body: some View {
        
        VStack {
        
            
            
            NavBar(left: {
                cancelButton()
            }, center: {
                Text("Select Dog")
                    .font(.headline)
                    .padding()
            }, right: {
                newDogSegue()
            })
            
            

            if #available(iOS 14.0, *) {
                List {
                    // MARK: MarkUP
                    ForEach(allDogs, id: \.self) { dog in
                        Button {
                            favoriteDog = dog
                            isPresented = false
                            
                            if updateFavoriteDogOnSelection == true {
                                dogs.updateFavorite(dog: dog, in: dogs.allDogs)
                            }
                        } label: {
                            
                            //                            DogRow(dog: dog)
                            if dog.isFavorite == 1 {
                                Text(dog.name ?? "")
                                    .frame(width: UIScreen.main.bounds.width - 20,
                                           height: 40,
                                           alignment: .leading)
                                    .foregroundColor(.blue)
                                    .padding()
                            } else {
                                Text(dog.name ?? "")
                                    .frame(width: UIScreen.main.bounds.width - 20,
                                           height: 40,
                                           alignment: .leading)
                                    .foregroundColor(.primary)
                                    .padding()
                            }
                            
                            
                        }
                        //                        .buttonStyle(PlainButtonStyle() )
                        
                    }
                    
                }
                .onAppear {
                    dogs.fetchAll()
                    allDogs = dogs.allDogs
                }
                .onChange(of: newDogEntryWasDismissed) { _ in
                    dogs.fetchAll()
                }
                .onChange(of: dogs.allDogs) { _ in
                    allDogs = dogs.allDogs
                }
            } else {
                // Fallback on earlier versions
            }
            
        }
        
    }
    
    func cancelButton() -> some View {
        Button {
            self.isPresented = false
        } label: {
            Text("Cancel")
                .font(.headline)
                .padding()
                .foregroundColor(.red)
        }
    }
    
}



//
//struct SelectDogList_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectDogList()
//    }
//}
