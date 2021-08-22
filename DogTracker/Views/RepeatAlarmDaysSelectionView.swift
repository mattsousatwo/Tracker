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
    var dateIntervals: [String] = ["One Time",
                                   "Every week",
                                   "Every two weeks",
                                   "Every three weeks",
                                   "Every month",
                                   "Every two months",
                                   "Every three months",
                                   "Every four months",
                                   "Every five months",
                                   "Every six months",
                                   "Every seven months",
                                   "Every eight months",
                                   "Every nine months",
                                   "Every ten months",
                                   "Every eleven months",
                                    "Every year"]
    
    
    @State var selectedDays: [Day] = []
    
    var body: some View {
        
        Form {
            Section(header: Text("Invterval") ) {
                Picker(selection: $repeatDaysSelection,
                       label: Text(dateIntervals[repeatDaysSelection])
                        .padding() ,
                       content: {
                        ForEach(0...dateIntervals.count - 1, id: \.self) { interval in
                            Text(dateIntervals[interval])
                                .padding()
                                .onTapGesture {
                                    repeatDaysSelection = interval
                                }
                        }
                       })
            }
            
            AlarmDaysSection(selectedDays: $selectedDays)
            
            

        }
        
        
    }
    
}



enum AlarmInterval: CaseIterable {
    case perWeek,
         perTwoWeeks,
         perThreeWeeks,
         perMonth,
         perTwoMonths,
         perThreeMonths,
         perFourMonths,
         perFiveMonths,
         perSixMonths,
         perSevenMonths,
         perEightMoths,
         perNineMonths,
         perTenMonths,
         perElevenMonths,
         perYear
}



struct RepeatAlarmDaysSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RepeatAlarmDaysSelectionView().previewLayout(.sizeThatFits)
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



