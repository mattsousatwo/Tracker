//
//  LoginView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/23/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @State private var user: String = ""
    @State private var pass: String = ""
    @State private var unlock: Bool = false
    
    var body: some View {
        NavigationView {
            
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 0)
                    .fill(LinearGradient(gradient: Gradient(colors: [.lightBlue, .lightGreen]),
                                         startPoint: .bottom,
                                         endPoint: .top))
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .opacity(0.6)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    .overlay(
                        HStack {
                            Icon(image: "person", color: .blue)
                                .opacity(0.7)
                            TextField("Username", text: $user)
                                .opacity(1.0)
                        }
                    )
                        .padding(5)
                    
                    
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .opacity(0.6)
                        .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                        .overlay(
                         HStack {
                                Icon(image: "lock.open", color: .blue)
                                    .opacity(0.7)
                                TextField("Password", text: $pass)
                                    .opacity(1.0)
                            }
                        )
                        .padding(5)
                    
                    
                    
                    NavigationLink(destination: MainView(), isActive: $unlock) {
                        Button(action: {
                            print("Submit")
                            self.unlock.toggle()
                        }) {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 200, height: 60)
                                .overlay(
                                    Text("Submit")
                                        .foregroundColor(.white)
                            )
                            
                            
                            .padding()
                        }
                    } // NavLink
                    
                    
                } // VStack
            
                
                
            }// ZStack
                .navigationBarBackButtonHidden(true)
            .navigationBarTitle("title")
//            .navigationBarHidden(true)
        }// NavView
        
        
        
    } // Body
    
} // LoginView

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


