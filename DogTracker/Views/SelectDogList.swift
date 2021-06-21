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
        return dogs.allDogs
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
                        .foregroundColor(.red)
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
                            
//                            DogRow(dog: dog)
                            if dog.isFavorite == 1 {
                                Text(dog.name ?? "")
                                    .foregroundColor(.blue)
                                    .padding()
                            } else {
                                Text(dog.name ?? "")
                                    .foregroundColor(.primary)
                                    .padding()
                            }
  
                            
                        }
//                        .buttonStyle(PlainButtonStyle() )
                        
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
