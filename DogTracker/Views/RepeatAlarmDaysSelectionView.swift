//
//  RepeatAlarmDaysSelectionView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/18/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct RepeatAlarmDaysSelectionView: View {
    
    
    @State private var repeatDaysSelection: Int = 0
    
    @State var selectedDays: [Day] = []
    
    var body: some View {
        
        Form {
            Section {
                Picker(selection: $repeatDaysSelection,
                       label: Text("Interval")
                        .padding() ,
                       content: {
                        ForEach(Day.allCases, id: \.self) { day in
                            Text(day.asString())
                                .padding()
                        }
                })
                
            }
            
            AlarmDaysSection(selectedDays: $selectedDays)
            
            

        }
        
        
    }
    
}







struct RepeatAlarmDaysSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RepeatAlarmDaysSelectionView()
    }
}



struct AlarmDaysSection: View {
   
    @Binding var selectedDays: [Day]
    
    var body: some View {
        Section(header: Text("Days")) {
            ForEach(Day.allCases, id: \.self) { day in
                row(day: day)
                    .padding()
            }
        }
        
        
    }
    
    func row(day: Day) -> some View {
        return
            Button {
                switch doesSelectedDaysContain(day: day) {
                case true:
                    remove(day)
                case false:
                    add(day)
                }
            } label: {
                HStack {
                    Text(day.asString() )
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(doesSelectedDaysContain(day: day) ? .primary : .clear)
                }
                
            }

    }
    
    /// Check if selected day is in selectedDays container
    func doesSelectedDaysContain(day: Day) -> Bool {
        if selectedDays.contains(day) == true {
            return true
        } else {
            return false
        }
    }
    
    /// Add selectedDay if day is not already in selectedDays
    func add(_ selectedDay: Day) {
        let dayIsAlreadySelected = selectedDays.first(where: {$0 == selectedDay })
        if dayIsAlreadySelected == nil {
            selectedDays.append(selectedDay)
        }
    }
    
    /// Remove selectedDay if day is already in selectedDays
    func remove(_ selectedDay: Day) {
        let dayIsAlreadySelected = selectedDays.first(where: {$0 == selectedDay })
        if dayIsAlreadySelected != nil {
            selectedDays.removeAll(where: {$0 == selectedDay })
        }
    }
   
   
}
