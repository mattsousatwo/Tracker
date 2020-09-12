//
//  ProgressCard.swift
//  DogTracker
//
//  Created by Matthew Sousa on 9/1/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct ProgressCard: View {

    @State private var width: CGFloat = 225.0
    @Binding var progress: Double
    var bg: [Color] = [Color.white,  Color.androidGreen]
    var title: String = "Temp Title"
    var heading: String = "Temp Head"
    var footer: String = "Temp Foot"
    
    var body: some View {

        VStack {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(gradient: Gradient(colors: bg),
                                     startPoint: .bottom,
                                     endPoint: .top) )
                .frame(width: UIScreen.main.bounds.width - 30, height: 300)
                .aspectRatio(contentMode: .fit)
                .overlay(
                    ProgressRingView(width: $width, progress: $progress)
                    
                    .padding()
            )
            
            HStack {
                VStack(alignment: .leading) {
                    Text(heading).font(.headline).foregroundColor(.gray)
                    Text(title)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.darkBlue)
                        .lineLimit(3)
                    Text(footer.uppercased())
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
    
    } // body
    
} // progressCard

struct ProgressCard_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCard(progress: .constant(0.4),
                     bg: [.lightPurple
                        ,.darkPurple],
                     title: "Header",
                     heading: "title",
                     footer: "foot")
    }
}
