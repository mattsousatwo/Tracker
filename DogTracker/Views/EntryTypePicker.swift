//
//  EntryTypePicker.swift
//  DogTracker
//
//  Created by Matthew Sousa on 12/4/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct EntryTypePicker: View {
    
    private let userDefaults = UserDefaults()
    private var bathroomTypes: [EntryType] = [.pee, .poop, .vomit]
    private var foodTypes: [EntryType] = [.food, .water]
    @State private var discreteMode: Bool = false
    
    @Binding var entryMode: EntryMode
    @Binding var type: Int
    
    init(entryMode: Binding<EntryMode>, type: Binding<Int>) {
        self._entryMode = entryMode
        self._type = type
    }

    var body: some View {
        
        RowWithIcon(image: "pawprint.fill") {
            // Set entry type
            Picker(selection: $type,
                   label: Text("")) {
                
                switch entryMode {
                case .bathroomMode:
                    ForEach(0..<bathroomTypes.count) { index in
                        let bathroomType = self.bathroomTypes[index]
                        switch discreteMode {
                        case true:
                            EntryTypePickerButton(title: bathroomType.discreteMode!,
                                                  id: index)
                        case false:
                            EntryTypePickerButton(title: bathroomType.rawValue,
                                                  id: index)
                        }
                    }
                case .foodMode:
                    ForEach(0..<foodTypes.count) { index in
                        
                        EntryTypePickerButton(title: self.foodTypes[index].rawValue,
                                              id: index)
                    }
                }
            }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
        }
        
        .onAppear {
            discreteMode = userDefaults.discreetMode()
        }
        
    }
    
    private struct EntryTypePickerButton: View, Hashable {
        let title: String
        let id: Int
        
        var body: some View {
            Text(title)
                .tag(id)
                .padding()
        }
        
        
    }
}

struct EntryTypePicker_Previews: PreviewProvider {
    static var previews: some View {
        EntryTypePicker(entryMode: .constant(EntryMode.bathroomMode),
                        type: .constant(0))
    }
}
