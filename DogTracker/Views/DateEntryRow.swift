//
//  DateEntryRow.swift
//  DogTracker
//
//  Created by Matthew Sousa on 12/4/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct DateEntryRow: View {
    
    @Binding var date: Date
    var components: DatePickerComponents = [.date, .hourAndMinute]
    
    var body: some View {
        RowWithIcon(image: "clock") {
            Spacer()
            DatePicker("Time",
                       selection: $date,
                       displayedComponents: components)
                .labelsHidden()
                .padding()

        }

    }
    
    
    
    
}

struct DateEntryRow_Previews: PreviewProvider {
    static var previews: some View {
        DateEntryRow(date: .constant(Date()),
                     components: [.date, .hourAndMinute])
    }
}
