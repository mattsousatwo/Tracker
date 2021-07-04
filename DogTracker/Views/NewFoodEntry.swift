//
//  NewFoodEntry.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/24/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI

struct NewFoodEntry: View {
    @ObservedObject var foods = Foods()
    
    @Binding var isPresented: Bool
    
    @State private var brandName: String = ""
    @State private var flavor: String = ""
    @State private var amountGiven: String = ""
    
    var body: some View {
        
        HStack {
            Button {
                self.isPresented.toggle()
            } label: {
                Text("Cancel")
                    .foregroundColor(.red)
                    .padding()
            }
            Spacer()
        }
        
        Form {
            TextField("Brand Name", text: $brandName)
                .padding()
            
            TextField("Flavor", text: $flavor)
                .padding()
            
            TextField("Amount", text: $amountGiven)
                .keyboardType(.decimalPad)
                .padding()
            
            Section {
                saveButton()
            }
        }
        
        
        
    }
    
    func saveButton() -> some View {
        Button {
            
//
//            foods.createNew(food: <#T##String#>)
//
        } label: {
            Text("Save")
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .font(.headline)
                
                .cornerRadius(15)
                .shadow(radius: 2)
            
        }
        
    }
}



struct NewFoodEntry_Previews: PreviewProvider {
    static var previews: some View {
        NewFoodEntry(foods: Foods(),
                     isPresented: .constant(true))
    }
}
