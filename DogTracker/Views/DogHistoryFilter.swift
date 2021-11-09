//
//  DogHistoryFilter.swift
//  DogTracker
//
//  Created by Matthew Sousa on 11/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct DogHistoryFilter: View {
    @Binding var type: EntryType
    @State private var text: String = "Filter"
    @State var expand: Bool = false
    @State var filterList: [FilterElement] = []
    
    var body: some View {
        switch expand {
        case false:
            Text(text)
                .fontWeight(.light)
                .padding()
                .background(Color.lightBlue)
                .cornerRadius(8)
                .onTapGesture {
                    updateText()
                    withAnimation {
                        expand = true
                    }
                }
                .animation(.easeIn)
        case true:
            VStack {
                Text(text)
            }
            .frame(width: 100)
            .padding()
            .background(Color.lightBlue)
            .cornerRadius(8)
            .onTapGesture {
                updateText()
                withAnimation {
                    expand = false
                }
            }
            .animation(.easeIn)
        }
        
    }
    
    /// update displayed text
    func updateText() {
        if filterList.count >= 1 {
            text = "\(filterList.count)"
        } else {
            text = "Filter"
        }
        
    }
}

struct DogHistoryFilter_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            DogHistoryFilter(type: .constant(.pee),
                             expand: false,
                             filterList: [])
            DogHistoryFilter(type: .constant(.food),
                             expand: true,
                             filterList: [])
            
        }.previewLayout(.sizeThatFits)
    }
}




/// Protocol to conform types to add to filter list
protocol FilterElement { }
extension BathroomEntry: FilterElement { }
extension FoodEntry: FilterElement { }
extension Food: FilterElement { }
