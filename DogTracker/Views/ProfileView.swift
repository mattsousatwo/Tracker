//
//  ProfileView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/27/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import UIKit
import SwiftUI

@available(iOS 15.0, *)
struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var dogs = Dogs()
    @ObservedObject var bathroomBreak = BathroomBreak()
    @ObservedObject var foodEntries = FoodEntries()
    let conversion = Conversion()
    
    var selectedDog: Dog
    
    
    @State private var changeImage = false
    @State private var editName = false
    @State private var editEmail = false
    @State private var editPass = false
    @State private var deleteAccount = false
    
    @State private var showDeleteAlert = false
    
    /// History Date
//    @State private var firstDate: Date = Date()
//    @State private var lastDate: Date = Date()
//    @State private var currentWeek: String = "Current Week"
//    @State private var graphWeek = Date().asFormattedString()
//
    
    // Dog Properties
    @State private var dogName: String = ""
    @State private var dogWeight: String = "0.0"
//    @State private var breeds: String = ""
//    @State private var birthdate: String = ""
    @State private var isFavorite: Bool = false
    @State private var dogImage = UIImage()
    @State private var perscriptions: [String] = ["Benadryl"]
    @State private var alarms: [String] = []
    
    @State private var alarmButton: Bool = false
    
    @State private var dogBirthdate: Date = Date()
    
    @State private var notes: String = "Notes"
    
    
    
    
    // Breeds
    @State private var displayToggle = false
    @State private var presentSelectBreedList = false
    @State private var selectedDogBreed: [String] = []
    @State private var editingMode = false
    
    
    /// BathroomMode: True, FoodMode: False
    @State var bathroomOrFoodMode: Bool = true
    /// History recordings
//    @State private var historyElements: [HistoryElement] = []
    
    /// Save the selected image to dog
    func saveImage() {
        selectedDog.update(image: dogImage)
    }
    
    
    
    /// Update the selected dogs properties with any new values
    func updateDog() {
        var dogsWeight: Double {
            if let weight = conversion.convertToDouble(string: dogWeight) {
                return weight
            }
            return 0
        }
        
        var favorite: FavoriteKey {
            if isFavorite == true {
                return .isFavorite
            } else {
                return .notFavorite
            }
        }
        
        
        selectedDog.update(name: dogName,
                           weight: dogsWeight,
                           breed: selectedDogBreed,
                           birthdate: dogBirthdate)
//                           isFavorite: favorite)
    }
    
    
    
    func saveButton() -> some View {
        return
            
            Button {
                
                
                updateDog()
                dismiss()
                
            } label: {
                Text("Save")
                    .foregroundColor(.blue)
                    .padding()
            }
        
        
            
    }
    
    // Footer button to delete dog
    func deleteDogFooter() -> some View {
        return
            HStack {
                Spacer()
                Button {
                    self.showDeleteAlert.toggle()
                } label: {
                    Text("Delete \(selectedDog.name ?? "Dog")")
                        .bold()
                        .foregroundColor(.red)
                    
                    
                }.alert(isPresented: $showDeleteAlert) {
                        Alert(title: Text("Warning"),
                              message: Text("Are you sure you would like to delete \(selectedDog.name ?? "the selected dog?")?"),
                              primaryButton: .default(Text("Delete"),
                                                      action: {
                                                        deleteDog()
                                                      }),
                              secondaryButton: .cancel(Text("Cancel")))
                    
                }
                
                Spacer()
            }.padding()

    }
    
    // Delete the current dog
    func deleteDog() {
        print("Dismiss View / Delete dog")
        
        dogs.deleteSpecificElement(.dog, id: selectedDog.uuid)
        
        dismiss()
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        
        
        
        Form {
            
            
            profileImage()
                .onAppear {
                    if let birthday = selectedDog.birthdate {
                        if let date = conversion.convertBirthdate(string: birthday) {
                            dogBirthdate = date
                            
                        }
                    }
                }
            
            Section(header: Text("Edit Information")) {
                
                Group {
                    
                    nameTexfield()
                    
                    editWeightfield()
                    
                    editBirthdateRow()
                        .onAppear(perform: {
                            if let breeds = dogs.decode(breeds: selectedDog.breed) {
                                selectedDogBreed = breeds
                            }
                        })
                    
                    
                    
                } // Group
                
            } // Section
            
            breedEntryView()
            
            
            Section(header: Text("History")) {
                NavigationLink(
                    //                    destination: HistoryView(),
                    destination: DogHistory(dog: selectedDog),
                    label: {
                        Text("View History").padding()
                    })
            }
            //                historySection()
            
            
            
            perscriptionSection()
            
            reminderSection()
            
            
            textView()
            
            
            
            
            
        } // Form
        .navigationTitle(Text(dogName) )
        
        .navigationBarItems(trailing: saveButton() )
        
        
        .onAppear {
            if let name = selectedDog.name {
                dogName = name
            }
            
            
            
            
            
            
            
            //
            //
            //                onAppearLoadHistoryElements()
            //
            guard let image = selectedDog.convertImage() else { return }
            self.dogImage = image
        }
        //
        //            .onChange(of: selectedDog, perform: { value in
        //                onAppearLoadHistoryElements()
        //            })
        .onChange(of: dogImage, perform: { value in
            saveImage()
        })
        
        
    } // Body
    
    
} // ProfileView


// Perscriptions
@available(iOS 15.0, *)
extension ProfileView {
    
    
    func createNewPrescriptionButton() -> some View {
        return
            NavigationLink(destination: NewPrescriptionView() ) {
                Text("Create New Perscription")
                    .foregroundColor(.blue)
                    .padding()
            }
    }
    
    func perscriptionSection() -> some View {
        return
            Section(header: Text("Perscriptions")) {
                
                if perscriptions.count != 0 {
                    
                    ForEach(perscriptions, id: \.self) { perscription in
                        NavigationLink(destination: Text("Perscription") ) {
                            HStack {
                                Text(perscription)
                                Spacer()
                                Button {
                                    self.alarmButton.toggle()
                                } label: {
                                    switch alarmButton {
                                    case true:
                                        Icon(image: "bell",
                                             color: .lightBlue)
                                        
                                    case false:
                                        
                                        Icon(image: "bell.slash",
                                             color: .lightBlue,
                                             buttonStatus: .inactive)
                                        
                                    }
                                }

                       
                            }
                                .padding()
                        }.buttonStyle(PlainButtonStyle() )
                        
                        

                    }
                    
                    createNewPrescriptionButton()
                    
                    
                } else {
                    
                    createNewPrescriptionButton()
                }
                
                
                
                
            }
    }
    
    
    
    
    
    
}



// Notes
@available(iOS 15.0, *)
extension ProfileView {
    
    func reminderSection() -> some View {
        return
            Section(header: Text("Alarms")) {
                
                if alarms.count != 0 {

                } else {
                    NavigationLink(destination: NewAlarm() ) {
                        Text("Create Custom Alarm")
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                
                
                
                
            }
    }
}

// TextView
@available(iOS 15.0, *)
extension ProfileView {
    
    func textView() -> some View {
        return
            Section {
                LargeTextView(text: $notes)
            } header: {
                Text("Notes")
            } footer: {
                deleteDogFooter()
            }

    }
    
}





// TextRows
@available(iOS 15.0, *)
extension ProfileView: DogImage {
    
    func profileImage() -> some View {
        return
            Section(header: Text("Image") ) {
                Button(action: {
                    self.changeImage.toggle()
                }) {
                    HStack {
                        Text("Select Image")
                            .foregroundColor(.primary)
                        Spacer( )
                        dogProfile(image: self.dogImage)
                    }
                } .sheet(isPresented: $changeImage) {
                    ImagePicker(selectedImage: self.$dogImage, sourceType: .photoLibrary)
                }
            }
        
    }
    
    /// Edit name check field
    func nameTexfield() -> some View {
        return
            // Edit Name
            HStack {
                // Icon
                Icon(image: "person",
                     color: .lightBlue,
                     frame: 40)
                
                TextField("Name:", text: $dogName)
                    .multilineTextAlignment(.trailing)
                    .padding()
                
            }
        
    }
    
    /// Edit weight field
    func editWeightfield() -> some View {
        return
            HStack {
                Icon(image: "scalemass",
                     color: .lightBlue,
                     frame: 40)
                
                TextField("Weight:", text: $dogWeight)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .padding()
            }
            .onAppear {
                dogWeight = String(selectedDog.weight)
            }
        
        
    }
    
    func editBirthdateRow() -> some View {
        return
            HStack {
                Icon(image: "giftcard",
                     color: .lightBlue,
                     frame: 40)
                
                Spacer()
                
                DatePicker("Date",
                           selection: $dogBirthdate,
                           displayedComponents: .date)
                            .labelsHidden()
                            .padding()
            }
    }
    
    
    func breedEntryView() -> some View {
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
            //                                .onChange(of: selectedDogBreed, perform: { _ in
            //                                    updateNewDogState()
            //                                })
            
            
            
            
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
    
    
}
