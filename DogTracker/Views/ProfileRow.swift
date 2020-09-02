//
//  ProfileRow.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/24/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct ProfileRow: View {
    // Image
    var profileImage: Image
    // Profile name
    var name: String
    // Profile highlights
    var highlights: String
    

    
    var body: some View {
        
        
        HStack {
            profileImage.resizable().clipShape(Circle())
                .frame(width: 75, height: 75, alignment: .topLeading)
                    .overlay(
                        Circle().stroke(Color.gray, lineWidth: 5)
                )
                    .padding()
            VStack {
                HStack {
                    Text(name).fontWeight(.bold)
                        .frame(alignment: .leading)
                        .padding(.top, 2)
                    Spacer()
                } // HS
                    
                HStack {
                    Text(highlights).fontWeight(.light )
                        .frame(alignment: .leading)
                        .padding(.top, 5)
                    Spacer()
                    } // HS
                } // VS
       
                Spacer()
                
            } // HStack
                
        
    
        
    } // Body
    
    
} // ProfileRow

struct ProfileRow_Previews: PreviewProvider {
    static var previews: some View {
        ProfileRow(profileImage: Image("Sand-Dog"), name: "Profile", highlights: "Highlights")
    }
}
