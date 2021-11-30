//
//  DogSwitcher.swift
//  DogTracker
//
//  Created by Matthew Sousa on 11/5/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct DogSwitcher: View, DogImage {
    @State private var present: Bool = false
    @State private var actionButtons: [ActionSheet.Button] = [.cancel()]
    @Binding var selectedDog: Dog
    var frame: CGFloat = 70
    
    var image: UIImage?
    
    var body: some View {
        
        Button {
            self.present.toggle()
        } label: {
            
            dogProfile(image: image)
                .shadow(radius: 5)
        }
        .actionSheet(isPresented: $present, content: { () -> ActionSheet in
            ActionSheet(title: Text("Select Dog"),
                        message: Text("Choose a dog to be set as a favorite"),
                        buttons: actionButtons)
        })
        .onAppear {
            let dogs = Dogs()
            if dogs.allDogs.count == 0 {
                dogs.fetchAll()
            }
            
            
            if dogs.allDogs.count != 0 &&
                actionButtons.count == 1 {
                
                for dog in dogs.allDogs {
                    if let name = dog.name {
                        let button = ActionSheet.Button.default(Text(name)) { selectedDog = dog
                            dogs.updateFavorite(dog: selectedDog, in: dogs.allDogs)
                        }
                        actionButtons.append(button)
                    }
                }
            }

        }
        
    }
}


struct DogSwitcher_Previews: PreviewProvider {
    static var previews: some View {
        DogSwitcher(selectedDog: .constant(Dog()),
                    frame: CGFloat(300),
                    image: nil)
           .previewLayout(.sizeThatFits)
    }
}
