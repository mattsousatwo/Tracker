//
//  StatsBar.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/29/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct StatsBar: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Up Next:").font(.system(size: 25,
                                             weight: .medium,
                                             design: .rounded))
                .padding(.horizontal)
            
            ScrollView(.horizontal ,showsIndicators: false) {
                HStack(alignment: .center, spacing: 25) {
                    StatCard(type: .bathroom1)
                    StatCard(type: .bathroom2)
                    StatCard(type: .food)
                    StatCard(type: .water)
                }.padding(.horizontal)
            }
        }
    }
}

struct StatsBar_Previews: PreviewProvider {
    static var previews: some View {
        StatsBar()
        StatCard(type: .bathroom1).previewLayout(.sizeThatFits)
    }
}

enum StatCardType {
    case bathroom1
    case bathroom2
    case food
    case water
    
    var color: Color {
        switch self {
        case .bathroom1:
            return .lightBlue
        case .bathroom2:
            return .lightBlue
        case .food:
            return .lightRed
        case .water:
            return .lightYellow
        }
    }
    
    var iconColor: Color {
        switch self {
        case .bathroom1:
            return .dBlue
        case .bathroom2:
            return .dBlue
        case .food:
            return .dRed
        case .water:
            return .dYellow
        }
    }
    
    var imageTitle: String {
        switch self {
        case .bathroom1:
            return ""
        case .bathroom2:
            return ""
        case .food:
            return ""
        case .water:
            return ""
        }
    }
    
    var title: String {
        switch self {
        case .bathroom1:
            return "Pee"
        case .bathroom2:
            return "Poop"
        case .food:
            return "Food"
        case .water:
            return "Water"
        }
    }

}

struct StatCard: View {
    
    var type: StatCardType
    
    var body: some View {
        
        
        RoundedRectangle(cornerRadius: 12)
            .frame(width: 120,
                   height: 175,
                   alignment: .center)
            .foregroundColor(type.color)
            .overlay(
                VStack {
                    
                    Icon(image: "phone",
                         color: type.iconColor,
                         frame: 40)
                    Spacer()
                    
                    Text("1:00")
                        .padding(5)
                    Text(type.title)
                        .foregroundColor(.textGrey)
//                        .opacity(0.8)
                }
                .padding(.horizontal, 5)
                .padding(.vertical)
                , alignment: .trailing)
        
        
    }
}
