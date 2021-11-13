//
//  FilterView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 11/10/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

@available(iOS 15.0, *)
struct FilterView: View {
    
    
    
    @Binding var filterList: Set<EntryType>
    

    
    var body: some View {
        
        // list of entry types
        
        
        
        List {
            ForEach(EntryType.allCases) { type in

                
                Button {
                    appendToFilterList(type)
                } label: {
                    HStack {
                        Text(type.rawValue)
                            .foregroundColor(filterList.contains(type) ? .lightBlue: .primary)
                        Spacer()
                    }
                    .padding()
                }
    
             
            }
            
        
            
        }
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                if filterList.count > 0 {
                    Button {
                        filterList.removeAll()
                    } label: {
                        Text("Clear")
                    }
                }

                
            }
            
        }
        
    }
    
    /// Add or remove entryType to filter list
    func appendToFilterList(_ type: EntryType) {
        switch filterList.contains(type) {
        case true:
            filterList.remove(type)
        case false:
            filterList.insert(type)
        }
    }
    
}

@available(iOS 15.0, *)
struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(filterList: .constant([]) )
    }
}


struct FilterRow: View {
    
    let title: EntryType
    
    @State private var isChosen: Bool = false
    
    
    var body: some View {
        
        Button {
            self.isChosen.toggle()
        } label: {
            HStack {
                Text(title.rawValue)
                    .foregroundColor(isChosen ? .lightBlue: .primary)
                Spacer()
            }
            .padding()
        }
        
        
    }

}
