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
        
        VStack {
            
            HStack {
                Button {
                    self.isPresented = false
                } label: {
                    Text("Cancel")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.gray)
                }

                Spacer()
                
                Text("Select Dog")
                    .font(.headline)
                    .padding()
                
                Spacer()
                Spacer()
                
            }

            List {
                // MARK: MarkUP
                if let allDogs = allDogs {
                    ForEach(allDogs, id: \.self) { dog in
                        Button {
                            favoriteDog = dog
                            isPresented = false
                            
                            dogs.updateFavorite(dog: dog, in: allDogs)
                        } label: {
                            
                            DogRow(dog: dog)

                        }
                        
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
