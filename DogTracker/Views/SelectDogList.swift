//
//  SelectDogList.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/7/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct SelectDogList: View {
    
    @Binding var favoriteDog: Dog
    @Binding var isPresented: Bool
    
    
    @State private var deleteMode: Bool = false
    
    let dogs = Dogs()
    
    var allDogs: [Dog]? {
        dogs.fetchAll()
        if let fetchedDogs = dogs.allDogs {
            return fetchedDogs
        }
        return nil
    }
    
    var body: some View {
        

        List {
            
            if let allDogs = allDogs {
                ForEach(allDogs, id: \.self) { dog in
                    Button {
                        favoriteDog = dog
                        isPresented = false
                        
                        dogs.updateFavorite(dog: dog, in: allDogs)
                    } label: {
                        if deleteMode == false {
                            DogRow(dog: dog).padding()
                        } else {
                            HStack {
                                Button(action: {
                                    print("Delete dog: \(dog.name ?? ""), \(dog.uuid) -- NOT SETUP")

                                    
                                }, label: {
                                    Icon(image: "globe", color: .red)
                                        .frame(width: 20,
                                               height: 20)

                                })
                                DogRow(dog: dog).padding()
                            }
                        }
   
                    }
                    
                }
            }
            
        }
        .overlay(
            Button(action: {
                withAnimation {
                    self.deleteMode.toggle()
                }
            }, label: {
                Icon(image: "globe", color: .red)
            })
            , alignment: .topTrailing)
        
    }
    
    
}
//
//struct SelectDogList_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectDogList()
//    }
//}
