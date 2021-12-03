//
//  DisplayListToggleRow.swift
//  DogTracker
//
//  Created by Matthew Sousa on 12/2/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

/// Row is intended to be placed above optional rows within a list. DisplayListToggle is used to toggle showing optional rows
struct DisplayListToggleRow: View {
    
    let title: String
    @Binding var displayList: Bool
    
    init(title: String, displayList: Binding<Bool>) {
        self.title = title
        self._displayList = displayList
    }
    
    var body: some View {
        
        
        Button {
            withAnimation {
                self.displayList.toggle()
            }
        } label: {
            HStack {
                
                Text("Extras").font(.subheadline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .frame(width: 20, height: 20)
                    .padding(5)
                    .rotationEffect(displayList ? .degrees(90) : .degrees(0))
                
            }

        }
    }
}

struct DisplayListToggleRow_Previews: PreviewProvider {
    static var previews: some View {
        
        
        DisplayListToggleRow(title: "Title", displayList: .constant(false))
        
        
        
    }
}
