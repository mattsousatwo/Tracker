//
//  DogRow.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct DogRow: View {
    
    var name: String
    var age: String
    var breed: String
    
    
    @State var isFavorite: Bool = false
    
    var size: CGFloat = 20
    
    var body: some View {
        
        
        HStack(alignment: .center) {
            
            switch isFavorite {
            case true:
                Icon(image: "checkmark.seal", color: .darkYellow)
            case false:
                Icon(image: "checkmark.seal", color: .clear)
            }
            
            HStack(alignment: .top) {
                
                VStack(alignment: .leading) {
                    Text(name).font(.system(size: 30, weight: .semibold, design: .rounded))
                        .padding(.top, 5)
                    Divider()
                    Text(breed).fontWeight(.thin)
                }.padding(5)
                
                Spacer()
                
                
                Text(age).fontWeight(.light)
                    .padding()
                
                
                
            }
        }
        
    }
}

struct DogRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DogRow(name: "Tito",
                   age: "10 Months",
                   breed: "Pomeranian",
                   isFavorite: false)
                .previewLayout(.sizeThatFits)
            
            DogRow(name: "Tito",
                   age: "10 Months",
                   breed: "Pomeranian",
                   isFavorite: true)
                .previewLayout(.sizeThatFits)
        }
    }
}
