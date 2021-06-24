//
//  NextBathroomCard.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/19/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct NextBathroomCard: View {
    
    var time: Double = 0.0
    private var nextBathroomState: NextBathroomState = .safe
    private var color: Color {
        switch nextBathroomState {
        case .safe:
            return .lightGreen
        case .upcomming:
            return .lightOrange
        case .imminent:
            return .red
        }
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundColor(color)
            .frame(width: (UIScreen.main.bounds.width / 2) + (UIScreen.main.bounds.width / 3),
                   height: 140,
                   alignment: .center)
            
            .overlay(
                VStack {
                    HStack {
                        Text("Next Bathroom:")
                            .font(.system(size: 30,
                                          weight: .bold,
                                          design: .rounded))
                            .padding(.top)
                            .padding(.leading)
                        Spacer()
                    }
                    HStack {
                        Text("Tito")
                            .font(.title)
                            .padding()
                        Spacer()
                        Text("0:24")
                            
                            .font(.system(size: 60,
                                          weight: .bold,
                                          design: .rounded))
                            .bold()
                            .padding(.trailing)
                            .padding(.bottom)
                    }
                }
            )
    }
}

struct NextBathroomCard_Previews: PreviewProvider {
    static var previews: some View {
        NextBathroomCard()
    }
}


enum NextBathroomState {
    case safe
    case upcomming
    case imminent
}
