//
//  HistoryModel.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/3/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI

struct HistroyModel {
    
    @State var firstDate: Date = Date()
    @State var lastDate: Date = Date()
    
    func convertToStringArray(dates: [Date]) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        var formattedDatesContainer: [String] = []
        for day in dates {
            formattedDatesContainer.append(formatter.string(from: day))
        }
        return formattedDatesContainer
    }

    /// Get dates for week begining with, firstDate
    func getDatesRangeFrom(start firstDate: Date) -> [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        let today = calendar.startOfDay(for: firstDate )
        let dayOfTheWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound )
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfTheWeek, to: today)}
        return days
    }
    
    
    func getFirstAndLastOfWeek() -> (first: String, last: String)? {
        
        let days = getDatesRangeFrom(start: firstDate)
        
        let formatter = DateFormatter()
        
        guard let firstDay = days.first else { return nil }
        let firstDayString = formatter.graphDateFormat(firstDay)
        
        guard let lastDay = days.last else { return nil }
        let lastDayString = formatter.graphDateFormat(lastDay)
        
        return (first: firstDayString, last: lastDayString)
    }
    
}

