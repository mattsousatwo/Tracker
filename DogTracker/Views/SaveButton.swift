//
//  SaveButton.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/24/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

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

struct SaveButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            SaveButton()
            MeasurementRow()
        }.previewLayout(.sizeThatFits)
    }
}


struct MeasurementRow: View  {
    
    @State private var selectedMeasurement: MeasurementType = .tableSpoon
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 40) {
            
            
            ForEach(MeasurementType.allCases, id: \.rawValue) { measurement in
                
                
                
                Text(measurement.rawValue).tag(measurement)
                    .lineLimit(1)
                    .font(.caption)
                    
                    .foregroundColor(selectedMeasurement == measurement ? .blue : .primary)
                    .onTapGesture {
                        updateSelection(measurement)
                    }
                
                
            }
            
            
            
        } // HStack
        
        .padding(.vertical)
        
    }
    
    // Update selected measurement
    func updateSelection(_ measurement: MeasurementType) {
        selectedMeasurement = measurement
    }
    
}


