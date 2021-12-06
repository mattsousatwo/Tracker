//
//  SelectDogRow.swift
//  DogTracker
//
//  Created by Matthew Sousa on 12/3/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

/// List Row with a dogs name used to trigger a sheet to select which dog the user would like to be displayed
@available(iOS 14.0, *)
struct SelectDogRow: View {
    
    let dogs = Dogs()
    
    @Binding private var assignedDog: Dog?
    @Binding var displaySheet: Bool
    @Binding var displayColor: Color?
    
    @State private var name: String = ""
    let updateFavoriteOnSelection: Bool
    
    init(dog: Binding<Dog?>,
         displaySheet: Binding<Bool>,
         displayColor: Binding<Color?>? = Binding.constant(.lightBlue),
         favoriteEditor: Bool = false) {
        
        self.updateFavoriteOnSelection = favoriteEditor
        self._assignedDog = dog
        self._displaySheet = displaySheet
        self._displayColor = displayColor ?? Binding.constant(.lightBlue)
    }
    
    
    var body: some View {
        
        
        HStack {
            successfulLoadBody()
            
            Spacer()
            Image(systemName: "chevron.right")
        }
        .onChange(of: assignedDog) { newValue in
            guard let assignedDog = assignedDog else { return }
            guard let dogName = assignedDog.name else { return }
            self.name = dogName
        }
        
    }

    /// Body for view after dogs name has been fetched
    func successfulLoadBody() -> some View {
        
            Button {
                self.displaySheet.toggle()
            } label: {
                Text(name)
                    .padding()
                    .foregroundColor(displayColor)
            }
            
            .sheet(isPresented: $displaySheet) {
                SelectDogList(dog: $assignedDog,
                              isPresented: $displaySheet,
                              favoriteEditor: updateFavoriteOnSelection)
            }
        

    }
    
    
    func loadViewBody() {
        guard let assignedDog = assignedDog else { return }
        guard let dogName = assignedDog.name else { return }
        name = dogName
        
    }

}

//struct SelectDogRow_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectDogRow()
//    }
//}
