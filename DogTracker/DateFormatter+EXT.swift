//
//  DateFormatter.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/5/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    func dateFormat(_ date: Date) -> String {
        self.dateFormat = "MMM d, yyyy"
        let formatedDate = self.string(from: date)
        return formatedDate
    }
    
    func timeFormat(_ date: Date) -> String {
        self.dateFormat = "HH:mm"
        let formattedTime = self.string(from: date)
        return formattedTime
    } 
}
