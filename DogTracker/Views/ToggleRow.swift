//
//  ToggleRow.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/26/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct ToggleRow: View {
    // Icon name
    var icon: String? = nil
    // Background Color
    var color: Color? = nil
    // Color of toggle
    var toggleColor: Color = .lightBlue
    // Title for row
    var title: String
    // Bool value for toggle
//    @Binding var isOn: Bool
    var isOn: Binding<Bool>?
    
    let userDefaults = UserDefaults()
    var setting: UserDefault? = nil 

    @State private var stateValue: Bool = false
    
    var body: some View {
        
        HStack {
            if let icon = icon,
               let color = color {
                Icon(image: icon, color: color)
                    .padding(5)
            }
            
//            Toggle(title, isOn: $isOn)
            if let isOn = isOn {
                if #available(iOS 14.0, *) {
                    Toggle(title, isOn: isOn)
                        .toggleStyle(SwitchToggleStyle(tint: toggleColor))
                        .padding(.trailing)
                } 
            } else {
                
                    if #available(iOS 14.0, *) {
                        Toggle(title, isOn: $stateValue)
                            .toggleStyle(SwitchToggleStyle(tint: toggleColor))
                            .padding(.trailing)
                            .onChange(of: stateValue, perform: { (_) in
                                if let setting = setting {
                                    if stateValue == false {
                                        userDefaults.update(default: setting,
                                                            value: .off)
                                        
                                    } else if stateValue == true {
                                        userDefaults.update(default: setting,
                                                            value: .on)
                                    }
                                }
                            })
                            .onAppear {
                                guard let setting = setting  else { return }
                                guard let value = userDefaults.getValue(from: setting) else { return }
                                print("setting: \(setting.tag ?? ""), stateValue: \(stateValue), value: \(value)")
                                stateValue = value
                                
                            }
                        
                    } else {
                        // Fallback on earlier versions
                    }
                    
                
            }
            
        } // HStack
        
    } // Body
} // ToggleRow

struct ToggleRow_Previews: PreviewProvider {
    static var previews: some View {
        ToggleRowWrapper()
      //  ToggleRow()
        
    } // previews
    
    struct ToggleRowWrapper: View {
        @State(initialValue: false) var code: Bool
        var body: some View {
            ToggleRow(icon: "globe", color: Color.blue, title: "title", isOn: $code)
        } // body
        
    } // ToggleRowWrapper
} // ToggleRow_Previews
