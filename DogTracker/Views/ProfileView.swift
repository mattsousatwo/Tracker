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
    
    func saveImage() {
        if let dog = selectedDog {
            dog.update(image: proImage)
        }
    }
    
    var body: some View {
        
        
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
            
            
            
        } // Form
       
        
            .onAppear {
                guard let favorite = dogs.fetchFavoriteDog() else { return }
                selectedDog = favorite

                guard let image = favorite.convertImage() else { return }
                self.proImage = image
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
