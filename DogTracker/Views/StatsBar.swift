//
//  StatsBar.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/29/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct StatsBar: View {
    
    @ObservedObject var userDefaults = UserDefaults()
    @State private var discreetMode: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            Text("Up Next:").font(.system(size: 25,
                                             weight: .medium,
                                             design: .rounded))
                .padding(.horizontal)
            
            ScrollView(.horizontal ,showsIndicators: false) {
                HStack(alignment: .center, spacing: 25) {
                    switch discreetMode {
                    case true:
                        StatCard(type: .discreet1)
                        StatCard(type: .discreet2)
                    case false:
                        StatCard(type: .bathroom1)
                        StatCard(type: .bathroom2)
                    }
                    StatCard(type: .food)
                    StatCard(type: .water)
                }.padding(.horizontal)
            }
        }.onAppear {
            discreetMode = userDefaults.discreteMode()
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
    case discreet1
    case discreet2
    case bathroom1
    case bathroom2
    case food
    case water
    
    var color: Color {
        return .lightBlue
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
        case .discreet1:
            return "1"
        case .discreet2:
            return "2"
        }
    }
    
    var time: String {
        switch self {
        case .bathroom1:
            return "1:32"
        case .bathroom2:
            return "1:45"
        case .food:
            return "4:23"
        case .water:
            return "40"
        case .discreet1:
            return "1:32"
        case .discreet2:
            return "1:45"
        }
    }
    
}

struct StatCard: View {
    
    var type: StatCardType
    
    var body: some View {
        
        
        RoundedRectangle(cornerRadius: 12)
            .frame(width: 150,
                   height: 200,
                   alignment: .center)
            .foregroundColor(type.color)
            .overlay(
                VStack {
                    
                    
                    Text(type.title)
                        .font(.title)
                        .foregroundColor(.primary)
                        .padding(5)
                    Spacer()
                    Text(type.time)
                        .fontWeight(.light)
                        .foregroundColor(.white)
//                        .opacity(0.8)
                }
                .padding(.horizontal, 5)
                .padding(.vertical)
                , alignment: .trailing)
        
        
    }
}
