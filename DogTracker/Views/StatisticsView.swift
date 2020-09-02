//
//  HistoryView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/21/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {
    
    var body: some View {
        NavigationView {
            
            ScrollView {
            
                // KEEP ----
                HStack {
                    Text("Predictions").bold()
                        .padding(.top, 5)
                        .padding(.leading)
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        PerdictionRow(topColor: Color.blue, bottomColor: Color("SlateBlue"), time: "1:30 PM")
                            .padding()
                            .shadow(radius: 5)
                        PerdictionRow(topColor: Color.blue, bottomColor: Color("DarkSlateBlue"), time: "2:15 PM") 
                            .padding()
                            .shadow(radius: 5)
                        PerdictionRow(topColor: Color("DarkSlateBlue"), bottomColor: Color.blue, time: "6:13 PM" )
                            .padding()
                            .shadow(radius: 5)
                    } // HStack
                } // HScroll
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.bottom)
                
                Divider()
                
                // ----
                
                Testing(title: "Title", description: "description", image: Image("Street-Dog"), price: 12.13, peopleCount: 4, ingredientCount: 15, category: "Spicy!", buttonHandler: nil)
//                StatisticsCard()
//                    .padding(.leading, 30)
                  LoginView()
                
                .navigationBarTitle(Text( "Statistics") )
            } // Scroll
        
       
        } // Nav
            
    } // Body
     
    
} // History

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
