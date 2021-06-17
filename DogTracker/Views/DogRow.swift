//
//  DogRow.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct DogRow: View {
    
    var dog: Dog
    
    @State var isFavorite: Bool = false
    
    @State var presentCreateNewDog: Bool = false
    
    var size: CGFloat = 20
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.lightBlue)
            .frame(width: .infinity, height: 150)
            .overlay(
        HStack(alignment: .top) {
            
            VStack(alignment: .leading) {
                if let name = dog.name {
                    Text(name).font(.system(size: size, weight: .semibold, design: .rounded))
                        .padding(.top, 5)
                }
                Divider()
                if let breed = dog.breed {
                    Text(breed).fontWeight(.thin)
                }
            }.padding(5)
            
            Spacer()
            
            VStack {
                Text("Age").fontWeight(.light)
                    .padding()
                switch isFavorite {
                case true:
                    Icon(image: "checkmark.seal", color: .darkYellow)
                        .frame(width: 20,
                               height: 20)
                        .padding()
                    
                case false:
                    Icon(color: .clear)
                        .frame(width: 20,
                               height: 20)
                }
            }
            
            
        }
            )
            
        .onAppear {
            switch dog.isFavorite {
            case 0:
                self.isFavorite = false
            case 1:
                self.isFavorite = true
            default:
                break
            }
        }
        
        
    }
}

//struct DogRow_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//
//            let dogs = Dogs()
//            let dog = dogs.createNewDog()
//
//            DogRow(dog: dog!,
//                   isFavorite: false)
//                .previewLayout(.sizeThatFits)
//
//            DogRow(name: "Tito",
//                   age: "10 Months",
//                   breed: "Pomeranian",
//                   isFavorite: true)
//                .previewLayout(.sizeThatFits)
//        }
//    }
//}
