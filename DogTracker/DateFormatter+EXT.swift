//
//  DateFormatter.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/5/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    /// Return date in "MMM d, yyyy" format
    func dateFormat(_ date: Date) -> String {
        self.dateFormat = "MMM d, yyyy"
        let formatedDate = self.string(from: date)
        return formatedDate
    }
    
    /// Return date in "MMM d" format
    func graphDateFormat(_ date: Date) -> String {
        self.dateFormat = "MMM d"
        let formatedDate = self.string(from: date)
        return formatedDate
    }
    
    /// Return date in "MMM d, h:mm a" format - Sep 1, 4:45 AM
    func foodHistoryFormat(_ date: Date) -> String {
        self.dateFormat = "E, MMM d - h:mm a"
        let formatedDate = self.string(from: date)
        return formatedDate
    }

    /// Compare two dates to see if they are equal 
    func compareDates(_ one: String, _ two: String) -> Bool? {
        if let dateOne = self.convertStringToDate(one),
           let dateTwo = self.convertStringToDate(two) {
            let componentsOne = [calendar.component(.month, from: dateOne),
                                 calendar.component(.day, from: dateOne),
                                 calendar.component(.year, from: dateOne)]
            let componentsTwo = [calendar.component(.month, from: dateTwo),
                                 calendar.component(.day, from: dateTwo),
                                 calendar.component(.year, from: dateTwo)]
            
            if componentsOne == componentsTwo {
                return true
            } else {
                return false
            }
        }
        return nil
    }
    
    func convertStringToDate(_ string: String) -> Date? {
//        self.dateFormat = "MMM d, yyyy"
        self.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        guard let formattedDate = self.date(from: string) else { return nil }
        return formattedDate
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
