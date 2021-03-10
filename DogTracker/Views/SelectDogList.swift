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
                    } label: {
                        DogRow(dog: dog).padding()
                    }
                }
            }
            
        }
        
    }
    
    
}
//
//struct SelectDogList_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectDogList()
//    }
//}
