//
//  HistoryView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/21/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    
                    VStack {
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .foregroundColor(.white)
                            
                            .frame(width: 20, height: 20)
                        
                        Text("Tito").fontWeight(.bold)
                            .frame(alignment: .trailing)
                            
                        
                    }
                        
                        .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.init("SlateBlue"), Color.init("DarkSlateBlue")]), startPoint: .top, endPoint: .bottom))

                        .cornerRadius(20)
                        .shadow(radius: 3)
                    
                
                        
                    Spacer()
                    Text("1:49 ").font(.title).fontWeight(.heavy)
                        
                    
                    Spacer()
                    
                }
                    .frame(width: 200, height: 50)
            
                .padding(.all)
                .background(Color.init("SlateBlue"))
                .cornerRadius(20)
                .shadow(radius: 10)
                Spacer()
                
                
                
                // KEEP ----
                Text("Predictions")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        PerdictionRow(topColor: Color.blue, bottomColor: Color("SlateBlue"))
                            .padding()
                            .shadow(radius: 5)
                        PerdictionRow(topColor: Color.blue, bottomColor: Color("DarkSlateBlue"))
                            .padding()
                            .shadow(radius: 5)
                        PerdictionRow(topColor: Color("DarkSlateBlue"), bottomColor: Color.blue )
                            .padding()
                            .shadow(radius: 5)
                    }
                }
                .background(Color.blue)
                .cornerRadius(10)
                
                // ----
                
                  
                
                .navigationBarTitle(Text( "History") )
            } // Scroll
        
       
        } // Nav
            
    } // Body
        
    
} // History

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
