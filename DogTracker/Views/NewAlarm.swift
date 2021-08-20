//
//  NewAlarm.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/18/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct NewAlarm: View {
    
    @State var date = Date()
    @State private var alarmLabel: String = ""
    
    func saveAction() {
        
    }
    
    var body: some View {
        
        Form {
            Section {
                DatePicker("Time",
                           selection: $date,
                           displayedComponents: .hourAndMinute)
                    .padding()
            }
            
            Section {
                NavigationLink(
                    destination: RepeatAlarmDaysSelectionView(),
                    label: {
                        Text("Day")
                            .padding()
                    })
                
                TextField("Alarm Label", text: $alarmLabel)
                    .padding()
                
            }
            
            
            
        }
        .navigationBarTitle(Text("New Alarm") )
        .navigationBarItems(trailing: SaveButton(action: saveAction() ))
        
        
        
    }
}


struct SaveButton: View  {
    
    var action: ()
    
    var body: some View {
        Button {
            action
        } label: {
            Text("Save")
                .padding()
        }
            
            
    }
}


struct NewAlarm_Previews: PreviewProvider {
    static var previews: some View {
        NewAlarm()
    }
}
