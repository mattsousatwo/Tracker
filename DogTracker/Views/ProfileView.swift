//
//  ProfileView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/27/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import UIKit
import SwiftUI

struct ProfileView: View {
    
    @ObservedObject private var dogs = Dogs()
    @State private var selectedDog: Dog? = nil
    
    @State private var changeImage = false
    @State private var editName = false
    @State private var editEmail = false
    @State private var editPass = false
    @State private var deleteAccount = false
    
    @State private var proImage =  UIImage()

    
    let conversion = Conversion()
    @ObservedObject var bathroomBreak = BathroomBreak()
    @ObservedObject var foodEntries = FoodEntries()
    
    
    @State var isOn: Bool = true
    
    
    @State private var historyElements: [HistoryElement] = []
    

    
    func saveImage() {
        if let dog = selectedDog {
            dog.update(image: proImage)
        }
    }
    
    var body: some View {
        
        
        if #available(iOS 14.0, *) {
            Form {
                
                Section(header: Text("Profile Image")) {
                    
                    HStack {
                        Spacer()
                        
                        ZStack {
                            // Profile Image
                            Image(uiImage: self.proImage).resizable().clipShape(Circle())
                                .frame(width: 150, height: 150, alignment: .topLeading)
                                .overlay(
                                    VStack {
                                        Spacer()
                                        ZStack {
                                            // Background for text
                                            Rectangle()
                                                .fill(Color.blue)
                                                .frame(width: 150, height: 40)
                                                .cornerRadius(10)
                                                .opacity(0.3)
                                                .shadow(radius: 5)
                                            // Label
                                            if #available(iOS 14.0, *) {
                                                Button(action: {
                                                    self.changeImage.toggle()
                                                }) {
                                                    Text("Change Image").font(.headline)
                                                        .foregroundColor(Color.white)
                                                    
                                                } .sheet(isPresented: $changeImage) {
                                                    ImagePicker(selectedImage: self.$proImage, sourceType: .photoLibrary)
                                                }
                                                .onChange(of: proImage, perform: { value in
                                                    saveImage()
                                                })
                                            }
                                        } // ZStack
                                        
                                        .frame(width: 152, height: 152)
                                        .overlay(
                                            Circle().stroke(Color.white, lineWidth: 5)
                                        )
                                        
                                    } // VStack
                                    
                                )
                            
                            
                            
                            
                        } // ZStack
                        
                        .padding()
                        .shadow(radius: 5)
                        
                        Spacer()
                        
                        
                    } // HS
                    
                    
                    
                    
                } // Section
                
                
                Section(header: Text("Edit Profile")) {
                    
                    Group {
                        
                        editNameButton()
                        
                        editEmailButton()
                        
                        editPasswordButton()
                        
                        
                    } // Group
                    
                } // Section
                
                
                Section {
                    
                    // Save button - TESTING - go to SwiftUIView
                    Button("Delete Account") {
                        self.deleteAccount.toggle()
                    }.sheet(isPresented: $deleteAccount) {
                        StatisticsView()
                    }
                    
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    .font(.headline)
                    .cornerRadius(15)
                    .shadow(radius: 2)
                    
                    
                }
                
                historySection()
                
                
            } // Form
            
            .onAppear {
                guard let favorite = dogs.fetchFavoriteDog() else { return }
                selectedDog = favorite
                
                onAppearLoadElements()
                
                guard let image = favorite.convertImage() else { return }
                self.proImage = image
                
            }
            .onChange(of: selectedDog, perform: { value in
                onAppearLoadElements()
            })
        }
        
        } // Body
    
    
} // ProfileView

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

// TextRows
extension ProfileView {
    
    func editNameButton() -> some View {
        return
            // Edit Name
            Button(action: {
                self.editName.toggle()
            }) {
                HStack {
                    // Icon
                    Image(systemName: "person")
                        .frame(width: 40, height: 40)
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(12)
                    // Label
                    Text("Change Profile Name")
                        .foregroundColor(Color.black)
                        .padding()
                    
                    Spacer()
                    
                    // Button Indicator
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.gray)
                }
                
            }.sheet(isPresented: $editName) {
                UpdateProfileView(updateStyle: .name,
                                  isPresented: $editName)
            }
    }
    
    func editEmailButton() -> some View {
        return
            // Edit Email
            Button(action: {
                self.editEmail.toggle()
            }) {
                HStack {
                    // Icon
                    Image(systemName: "paperplane")
                        .frame(width: 40, height: 40)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(12)
                    
                    // Label
                    Text("Change Email Address")
                        .foregroundColor(Color.black)
                        .padding()
                    
                    Spacer()
                    
                    // Button Indicator
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.gray)
                }
                
            }.sheet(isPresented: $editEmail) {
                UpdateProfileView(updateStyle: .email,
                                  isPresented: $editEmail)
            }
    }
    
    func editPasswordButton() -> some View {
        return
            // Edit Password
            Button(action: {
                self.editPass.toggle()
            }) {
                HStack {
                    // Icon
                    Image(systemName: "lock")
                        .frame(width: 40, height: 40)
                        .background(Color.red)
                        .foregroundColor(Color.white)
                        .cornerRadius(12)
                    
                    // Label
                    Text("Change Password")
                        .foregroundColor(Color.black)
                        .padding()
                    
                    Spacer()
                    
                    // Button Indicator
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.gray)
                    
                    
                }
                
            }.sheet(isPresented: $editPass) {
                UpdateProfileView(updateStyle: .password,
                                  isPresented: $editPass)
            }
    }
    
}


extension ProfileView {
    
    func section(_ entry: HistoryElement) -> some View {
        return
            VStack(alignment: .leading) {
                if entry.entries.count != 0 {
                    Text(entry.name)
                        .fontWeight(.bold)
                        .padding(.vertical)
                    Divider()
                    ForEach(0..<entry.entries.count, id: \.self) { i in
                        if let date = conversion.historyRowFormat(entry.entries[i].date) {
                            VStack(alignment: .leading) {
                                Text(date)
                                    .padding(.vertical)
                                if i != entry.entries.count - 1 {
                                    Divider()
                                }
                            }
                        }
                        
                    }
//                    .onDelete { index in
//                        deleteBathroomEntry(at: index, entries: entry.entries)
//                    }
                    
                }
                
            }
        
    }
    
    func getAllBathroomEntriesByDog() -> [HistoryElement] {
        if bathroomBreak.bathroomEntries?.count == 0 {
            bathroomBreak.fetchAll()
        }
 
        var entries = [BathroomEntry]()
        var elements = [HistoryElement]()
        
        if let selectedDog = selectedDog {
            if let dogsEntries = bathroomBreak.fetchAllEntries(for: selectedDog.uuid) {
                entries = dogsEntries.sorted(by: { (entryOne, entryTwo) in
                    guard let dateOne = entryOne.date, let dateTwo = entryTwo.date else { return false }
                    return dateOne < dateTwo
                    
                })
            }
            
            if let name = selectedDog.name {
                elements.append(HistoryElement(name: name, entries: entries))
            }
        
        }
        return elements
    }

    func deleteBathroomEntry(at offset: IndexSet, entries: [BathroomEntry]) {
        offset.forEach { (index) in
            
            if let bathroomID = entries[index].uid {
                bathroomBreak.deleteSpecificElement(.bathroomBreak, id: bathroomID)
            }
            onAppearLoadElements()
            
        }
    }
    
    func onAppearLoadElements() {
        historyElements = getAllBathroomEntriesByDog()
        if isOn == true {
            bathroomBreak.fetchAll()
        } else {
            foodEntries.fetchAll()
        }
//        print("Bathroom Use count \(bathroomBreak.bathroomEntries?.count)")
    }
    
    func historySection() -> some View {
        return
            Section(header:
                HStack {
                    Text(isOn ? "Bathroom Use" : "Food Consumption")
                    Spacer()
                    if #available(iOS 14.0, *) {
                        Toggle(isOn: $isOn) {
                            Text("")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .padding(.bottom, 5)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            ) {
               
                
                switch isOn {
                case true:
                    
                    ForEach(historyElements, id: \.self) { entry in
                        if entry.entries.count != 0 {
                            section(entry)
                        }
                    }
                    
                case false:
                    if let entries = foodEntries.entries {
                        if entries.count >= 1 {
                            
                            ForEach(entries, id: \.self) { entry in
                                if let date = entry.date {
                                    
                                    if let date = conversion.convertDate(date), let convertedDate = conversion.formatDateToNormalStyle(date) {
                                        Text(convertedDate)
                                            .padding()
                                    }
                                }
                            }
//                            .onDelete(perform: deleteFoodEntry )
                            
                        } else {
                            Text("There are 0 food entries")
                        }
                        
                        
                        
                    }
                }
                

            }
     
    }
}
