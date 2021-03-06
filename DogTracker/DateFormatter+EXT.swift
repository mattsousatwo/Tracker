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
    
    func twelveHourFormat(_ date: Date) -> String {
        self.dateFormat = "HH:mm"
        let pm: String = " PM"
        let am: String = " AM"
        var formattedTime = self.string(from: date)
        print(formattedTime)
        let firstHourIndex = formattedTime.index(formattedTime.startIndex, offsetBy: 0)
        let secondHourIndex = formattedTime.index(formattedTime.startIndex, offsetBy: 1)
        
        let firstHour: Character = formattedTime[firstHourIndex]
        let secondHour: Character = formattedTime[secondHourIndex]
        
        if firstHour == "0" {
            formattedTime.remove(at: firstHourIndex)
        }
        
        
        if let hourOne = firstHour.wholeNumberValue {
            if let hourTwo = secondHour.wholeNumberValue {
                
                if let hours = Int("\(hourOne)\(hourTwo)") {
                    if hours >= 12 {
                        let convertedHours = hours.convertToTwelveHourClock()
                        if convertedHours >= 10 {
                            formattedTime.remove(at: firstHourIndex)
                            formattedTime.remove(at: firstHourIndex)
                        } else {
                            formattedTime.remove(at: firstHourIndex)
                        }
                        formattedTime = "\(convertedHours)" + formattedTime + pm
                        print("hour: \(hours)")
                    } else {
                        formattedTime.append(am)
                    }
                }
                print(formattedTime)
            }
        }
        
        
        return formattedTime
    } 
}
