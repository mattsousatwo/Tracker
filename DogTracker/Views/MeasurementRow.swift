//
//  MeasurementRow.swift
//  MeasurementRow
//
//  Created by Matthew Sousa on 9/10/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct MeasurementRow: View  {
    
    @Binding var measurement: MeasurementType
    
    var spacing: CGFloat = 40
    
    var body: some View {
        
        HStack(alignment: .center, spacing: spacing) {
            
            
            ForEach(MeasurementType.allCases, id: \.rawValue) { measurement in
                
                Text(measurement.rawValue).tag(measurement)
                   
                    .fixedSize(horizontal: true, vertical: true)
                    .lineLimit(1)
                    
                    .font(self.measurement == measurement ? .body : .caption)
                    .foregroundColor(self.measurement == measurement ? .blue : .primary)
                    
                    .onTapGesture {
                        updateSelection(measurement)
                    }
                
                
            }
            
            
            
        } // HStack
        
        .padding(.vertical)
        
    }
    
    // Update selected measurement
    func updateSelection(_ measurement: MeasurementType) {
        self.measurement = measurement
    }
    
}
