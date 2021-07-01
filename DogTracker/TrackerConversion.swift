//
//  TrackerConversion.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/16/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation

class TrackerConversion {
    
    let bathroomBreak = BathroomBreak()
    let formatter = DateFormatter()
    
    // Convert Bathroom use into frequency of time
    func getFrequencyOfBathroomUse() {
        
        bathroomBreak.fetchAll()
        if let entries = bathroomBreak.bathroomEntries {
            
 
            
            
            for entry in entries {
                convertDate(entry.date)
                convertTime(entry.time)
                print("\n")
            }
            
        }
    }
    
    // 
    
    func convertTime(_ timeString: String?) -> Date? {
        guard let timeString = timeString else { return nil }
        formatter.timeStyle = .short
        guard let time = formatter.date(from: timeString) else { return nil }
        print("Time: \(time)")
        return time
    }

    func convertDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        let format = "MMM/d/yyyy"
        formatter.dateFormat = format
        guard let date = formatter.date(from: dateString) else { return nil }
        print("Date: \(date)")
        return date
        
    }
    
}




