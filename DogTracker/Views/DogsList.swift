//
//  DogsForm.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct DogsList: View {
    
    let dogs = ["Tito", "Rosie", "Bandit", "Tessa"]
    
    var body: some View { 

        List {
            
            
            ForEach(dogs, id: \.self) { dog in
                Text(dog)
            }
            
            
        }
        


    }
    
    
}

struct DogsList_Previews: PreviewProvider {
    static var previews: some View {
        DogsList()
    }
}
