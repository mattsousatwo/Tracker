//
//  ProfileView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/27/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var editName = false
    @State private var editEmail = false
    @State private var editPass = false
    
    var body: some View {
        
        
        Form {
    
            Section(header: Text("Profile Image")) {
                HStack {
                    Spacer()
                    
                    Image("Street-Dog").resizable().clipShape(Circle())
                        .frame(width: 150, height: 150, alignment: .topLeading)
                            .overlay(
                                Circle().stroke(Color.gray, lineWidth: 5)
                        )
                            
                    Spacer()
                    
                } // HS
                    
            } // Section
            
            
            Section(header: Text("Edit Profile")) {
                
                Group {
                    
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
                        StatisticsView()
                    }
                        
                    
                    
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
                        StatisticsView()
                    }
                                            
                    
                    
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
                        StatisticsView()
                    }
                        
                    
                } // Group
                
            } // Section
            
            
            Section {
                Text("DELETE ACCOUNT ROW")
            }
            
            
        } // Form
        
        
    } // Body
    
    
} // ProfileView

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
