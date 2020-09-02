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
    
    @State private var width: CGFloat = 200.0
    @State private var progress: Double = 0.7
    
    var body: some View {

        
        VStack {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.white,  Color.androidGreen]), startPoint: .bottom, endPoint: .top) )
                .frame(width: UIScreen.main.bounds.width - 30, height: 300)
                .aspectRatio(contentMode: .fit)
                .overlay(
                    ProgressRingView(width: $width, progress: $progress)
                    .padding()
            )
            
            
            HStack {
                VStack(alignment: .leading) {
                    Text("SwiftUI").font(.headline).foregroundColor(.gray)
                    Text("Drawing a border with rounder edges")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.darkBlue)
                        .lineLimit(3)
                    Text("Written by Tito Brophy".uppercased())
                        .font(.caption)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            self.progress = 1.0
                    }
                }
            .layoutPriority(100)
                
                Spacer()
            }
            .padding()
        }
        .cornerRadius(15)
        .padding(.vertical)
        
        
        
    
    } // Body
    
} // LoginView

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


