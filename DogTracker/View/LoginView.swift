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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    GeometryReader { geometry in
                        Text("Learn design & code. \nFrom scratch.")
                            .font(.system(size: geometry.size.width/10, weight: .bold))
                        
                    }
                    .frame(maxWidth: 375)
                    .padding(.horizontal, 16)
                    
                    
                    
                    TextField("username", text: $user)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                        
                        
                    TextField("passowrd", text: $pass)
                    
                        
                    .padding()
                        .background(Color.blue)
                    .cornerRadius(12)
                }
                .multilineTextAlignment(.center)
                .padding(.top, 100)
                .frame(height: 477)
                .frame(maxWidth: .infinity)
//                .background(Image(uiImage: UIImage.init(named: "Corgi-1")!), alignment: .bottom)
                    .background(Image("Street-Dog").resizable(), alignment: .center)
                
                
                
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                
                
                
                
            } // VStack
        } // ZStack
        
        
        } // Body
    
} // LoginView

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
