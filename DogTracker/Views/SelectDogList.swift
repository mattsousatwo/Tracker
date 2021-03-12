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
                Button(action: {
                    withAnimation {
                        self.deleteMode.toggle()
                    }
                }, label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(.trailing)
                })
                
            }
            
            
            List {
                
                if let allDogs = allDogs {
                    ForEach(allDogs, id: \.self) { dog in
                        Button {
                            favoriteDog = dog
                            isPresented = false
                            
                            dogs.updateFavorite(dog: dog, in: allDogs)
                        } label: {
                            if deleteMode == false {
                                DogRow(dog: dog)
                            } else {
                                HStack {
                                    Button(action: {
                                        print("Delete dog: \(dog.name ?? ""), \(dog.uuid) -- NOT SETUP")
                                        
                                        
                                    }, label: {
                                        
                                        
                                        Image(systemName: "minus.circle").resizable()
                                            .foregroundColor(.red)
                                            .padding(.horizontal, 5)
                                            .frame(width: 20,
                                                   height: 20)
                                        
                                        
                                    })
                                    DogRow(dog: dog)
                                }
                            }
                            
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
