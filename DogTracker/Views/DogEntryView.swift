//
//  DogEntryView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

/// Titles for each property in DogEntryView
 enum DogEntryScript: String {
    case emptyString = ""
    case defaultBreedString = "Select Breed:"
    case name = "Name:"
    case birthdate = "Birthdate:"
    case weight = "Weight:"
    case setFavorite = "Set as favorite"
    
}

enum DogEntryViews: String {
    case name = "Name"
    case weight = "Weight"
    case breed = "Breed"
}

/// Type to contain states of access for dog properties
enum SaveDogState {
    case accepted, denied, standard

}


struct DogEntryView: View {
    
    
    
    
    // MARK: TO DO -
    // Convert Weight to Double
    // Convert Date to accepted date
    @State private var birthdate = Date()
    
    
    
    @Binding var isPresented: Bool
    @Binding var didDismiss: Bool
    
    @State private var displayToggle: Bool = false
    @State private var editingMode: Bool = false
    
    @State private var acceptNewDogState: SaveDogState = .standard
    @State private var buttonColor: Color = .gray
    @State private var saveWasPressed: Bool = false
        
    @State private var name: String = DogEntryScript.emptyString.rawValue
    @State private var weight: String = DogEntryScript.emptyString.rawValue
    
    @State private var isFavorite: Bool = false
    
    
    @State private var presentSelectBreedList: Bool = false
    @State private var selectedDogBreed: [String] = []
    
    @ObservedObject var dogs = Dogs()
    var selectedDog: Dog? = nil
//    var dogID: String? = nil
    
    
    
    /// If return nil all feilds are complete else return value of feild that needs to be updated
    private func detectIncompleteView() -> DogEntryViews? {
        if name == DogEntryScript.emptyString.rawValue {
            return .name
        } else if weight == DogEntryScript.emptyString.rawValue {
            return .weight
        } else if selectedDogBreed == [] {
            return .breed
        }
        return nil
    }
    
    private func disableSaving() {
        if saveWasPressed == true {
            acceptNewDogState = .denied
            buttonColor = .red
        } else {
            acceptNewDogState = .standard
            buttonColor = .gray
        }
    }
    
    /// Look through dog properties to see if new dog can be created || if so enable save else disable save
    private func updateNewDogState() {
        
        let incompleteView = detectIncompleteView()
        
        switch incompleteView {
        case .name:
            disableSaving()
            
        case .weight:
            disableSaving()
            print("weight: \(weight)")
        case .breed:
            disableSaving()
            
        case nil: // All Fields are complete
            acceptNewDogState = .accepted
            buttonColor = .blue
        }
        
        print("IncompleteView: \(incompleteView?.rawValue ?? "nil")")
        
        
        
        
        
        
//        if name != DogEntryScript.emptyString.rawValue,
//           weight != DogEntryScript.emptyString.rawValue,
//           selectedDogBreed != [] {
//
//            acceptNewDogState = .accepted
//            buttonColor = .blue
//        } else {
//            if saveWasPressed == true {
//                acceptNewDogState = .denied
//                buttonColor = .red
//            } else {
//                acceptNewDogState = .standard
//                buttonColor = .gray
//            }
//        }
//
        
    }
    
    // Convert selected weight to double
    func convertWeightToInt() -> Double? {
        if weight != "" {
            if let s = Double(weight) {
                return s
            }
        }
        return nil
    }
    
 
    /// Return save button
    private func saveButton() -> some View {
        var editingMode: Bool {
            if let _ = selectedDog {
                return true
            } else {
                return false
            }
        }
        let button = Button(editingMode ? "Update" : "Save") {
            
            saveWasPressed = true
            updateNewDogState()
            
            if acceptNewDogState == .accepted {
                
                if isFavorite == true {
                    dogs.clearFavoriteDog()
                }
                var dogsWeight: Double {
                    if let weight = convertWeightToInt() {
                        return weight
                    }
                    return 0
                }
                
                switch editingMode {
                case true :
                    
                    var favorite: DogFavoriteKey {
                        if isFavorite == true {
                            return .isFavorite
                        } else {
                            return .notFavorite
                        }
                    }
                    
                    selectedDog?.update(name: name,
                                        weight: dogsWeight,
                                        breed: selectedDogBreed,
                                        birthdate: birthdate,
                                        isFavorite: favorite)
                case false :
                    let _ = dogs.createNewDog(name: name,
                                              breed: selectedDogBreed,
                                              weight: dogsWeight,
                                              birthdate: birthdate,
                                              isFavorite: isFavorite)
                }

                
                // Dismiss View
                isPresented = false
                didDismiss = true
                
            } else {
                buttonColor = .red
                    
            }

            // https://swiftwithmajid.com/2020/05/06/building-calendar-without-uicollectionview-in-swiftui/
            
            print("isPresented: \(isPresented), didDismiss: \(didDismiss), acceptNewDogState: \(acceptNewDogState), editingMode: \(editingMode)")
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(buttonColor)
        .foregroundColor(Color.white)
        .font(.headline)
        .cornerRadius(15)
        .shadow(radius: 2)
//        .animation(.default)
        return button
    }
    
    var body: some View {

        if #available(iOS 14.0, *) {
            Form {
                Section(header: Text("Name").textCase(.none)) {
                    // MARK: Name
                    TextField(DogEntryScript.name.rawValue,
                              text: $name)
                        .onChange(of: name, perform: { _ in
                            updateNewDogState()
                        })
                        .padding()
                    
                    
                
                
                }
                
                
                // MARK: Select Breed
                Section(header:
                            HStack {
                                Text("Breed")
                                    .textCase(.none)
                                Spacer()
                                Button {
                                    self.presentSelectBreedList.toggle()
                                } label: {
                                    Text("Add")
                                        .textCase(.none)
                                        .padding(.trailing)
                                }.sheet(isPresented: $presentSelectBreedList) {
                                    SelectDogBreedList(isPresented: $presentSelectBreedList,
                                                       selectedBreed: $selectedDogBreed)
                                }
                                .onChange(of: selectedDogBreed, perform: { _ in
                                    updateNewDogState()
                                })
                                
                            }
                ) {
                    
                    
                    Button {
                        withAnimation {
                            self.displayToggle.toggle()
                        }
                    } label: {
                        HStack {
                            
                            breedsTitle()
                                .animation(.none)
                            
                            Spacer()
                            
                            if editingMode == false {
                                
                                menuIndicator()
                                    
                                    .rotationEffect(.degrees(displayToggle ? 90 : 0), anchor: .center)
                                    .animation(displayToggle ? .easeIn : nil)
                                
                            } else if editingMode == true {
                                
                                doneButton()
                            }
                        }
                        
                    }
                    
                    .padding()
                    
                    if displayToggle == true {
                        
                        ForEach(0..<selectedDogBreed.count, id: \.self) { i in
                            HStack {
                                if editingMode == true {
                                    
                                    minusButton(removeAtIndex: i)
                                }
                                Text(selectedDogBreed[i])
                                    .padding(10)
                                Spacer()
                                
                            }
                            .padding()
                            .onLongPressGesture {
                                self.editingMode = true
                            }
                            

                        }
                    }
                }
                

                Section(header: Text("Birthday").textCase(.none)) {
                    // MARK: Birthday
                    HStack {
                        
                        Icon(image: "giftcard", color: .lightGreen)
                            
                        // Set Time for entry
                        DatePicker("Set Time", selection: $birthdate, displayedComponents: .date)
                            .labelsHidden()
                            .padding()
                            .onChange(of: birthdate) { _ in
                                updateNewDogState()
                            }
                        
                    }
                }
                
                    // MARK: Weight
                Section(header: Text("Weight").textCase(.none)) {
                    
                    HStack {
                        
                        Icon(image: "scalemass", color: .lightOrange)
                        
//                        TextFieldWithDoneButton(text: $weight, keyType: .decimalPad)
                        TextField(DogEntryScript.weight.rawValue, text: $weight)
                            .keyboardType(.decimalPad)
                            .padding()
                            
                            
                            .onChange(of: weight, perform: { _ in
                                updateNewDogState()
                            })
                    }

                }
                
                Section(header: Text("Favorite").textCase(.none)) {
                    // MARK: Set Favorite
                    
                    ToggleRow(title: DogEntryScript.setFavorite.rawValue,
                              isOn: $isFavorite)
                        .font(.body)
                        .padding()
                        
                        
                 
                    
                    
                    
                    
                }
                
                saveButton()
            }
            .navigationBarTitle(Text("New Dog"))
            .onAppear {
                updateViews()
            }
        }
        
        
        
        
    }
    
    
    
    
    
    func updateViews() {
            if let selectedDog = selectedDog {
                print("Editing Dog Mode")
                name = selectedDog.name ?? DogEntryScript.emptyString.rawValue
                weight = "\(selectedDog.weight)"
                
                let formatter = DateFormatter()
                if let date = selectedDog.birthdate {
                    formatter.dateFormat = "yyyy/MM/dd"
                    if let convertedDate = formatter.date(from: date) {
                        birthdate = convertedDate
                    }
                }
                
                switch selectedDog.isFavorite {
                case 1:
                    isFavorite = true
                default:
                    isFavorite = false
                }
                if let decodedBreeds = selectedDog.decodeBreeds() {
                    selectedDogBreed = decodedBreeds
                }
                
            }
        
    }
    
    func minusButton(removeAtIndex i: Int) -> some View {
        return Image(systemName: "minus")
            .frame(width: 20, height: 20)
            .padding(5)
            .foregroundColor(editingMode ? .white : .clear)
            .background(editingMode ? Color.red : .clear)
            .opacity(editingMode ? 1.0 : 0.0)
            .mask(Circle())
            .animation(editingMode ? .default : nil)
            .transition(AnyTransition.opacity.combined(with: .move(edge: .leading)))
            .onTapGesture {
                withAnimation(.default) {
                    if editingMode == true {
                        // delete row
                        selectedDogBreed.remove(at: i)
                    }
                }
            }
            .animation(.default, value: selectedDogBreed)
    }
    
    func breedsTitle() -> some View {
        return HStack {
            Text("Breeds").font(.subheadline)
                .foregroundColor(.primary)
                .padding(.leading, 10)
                .padding(.vertical, 10)
        
            Text("(\(selectedDogBreed.count))").font(.subheadline)
                .foregroundColor(.gray)
        }
    }
    
    func menuIndicator() -> some View {
        return
            Image(systemName: "chevron.right")
            .frame(width: 20, height: 20)
            .padding(5)
//            .rotationEffect(displayToggle ? .degrees(90) : .degrees(0),
//                            anchor: .center)
//            .animation(.default)
//            .animation(displayToggle ? .default : nil)
    }
    
    func doneButton() -> some View {
        return
            Button {
                self.editingMode = false
            } label: {
                Text("Done")
                    .bold()
                    .foregroundColor(.blue)
            }
    }
}

struct DogEntryView_Previews: PreviewProvider {
    static var previews: some View {
        DogEntryView(isPresented: .constant(true ), didDismiss: .constant(false), selectedDog: nil)
    }
}
