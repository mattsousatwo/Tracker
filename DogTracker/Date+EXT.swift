//
//  Date+EXT.swift
//  RoomTracker
//
//  Created by Matthew Sousa on 3/31/21.
//

import Foundation

extension Date {
    
    /// Convert date to string as "May 12, 1994"
    func asFormattedString() -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.dateFormat(self)
    }
    
    
    /// Create a specific date
    func createDate(month: Int, day: Int, year: Int) -> String? {
        let calendar = Calendar.current
        let dateComponents = DateComponents(calendar: calendar,
                                            year: year,
                                            month: month,
                                            day: day)
        let date = calendar.date(from: dateComponents)
        let formattedDate = date?.asFormattedString()
        
        return formattedDate
    }
    
    /// add one day to date
    func addOneDay() -> Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    
    /// subtract one day to date
    func subtractOneDay() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    
    /// add one week to date
    func addOneWeek() -> Date? {
        return Calendar.current.date(byAdding: .day, value: 7, to: self)
    }

    /// subtract one week to date
    func subtractOneWeek() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)
    }

    /// add one month to date
    func addOneMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }

    /// Set date to one month prior to date
    func subtractOneMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    /// Set date to first of calendar month
    func startOfTheMonth() -> Date? {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))
    }
    
    /// Set date to first of calendar week
    func startOfTheWeek() -> Date? {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .yearForWeekOfYear, .weekOfYear], from: Calendar.current.startOfDay(for: self)))
    }
    
    // find end of week from date
    func endOfTheWeek(from day: Date) -> Date? {
        guard let pluOneWeek = day.addOneWeek() else { return nil }
        guard let minusOneDay = pluOneWeek.subtractOneDay() else { return nil }
        return minusOneDay
    }
    
    // Find the last day of the month
    func endOfTheMonth(from day: Date) -> Date? {
        guard let begginingOfTheMonth = day.startOfTheMonth() else { return nil }
        guard let plusOneMonth = begginingOfTheMonth.addOneMonth() else { return nil }
        guard let lastDayOfMonth = plusOneMonth.subtractOneDay() else { return nil }
        return lastDayOfMonth
    }
    
    /// Get dates between dates
    func allFormattedDatesBetween(_ fromDate: Date, to toDate: Date) -> [String] {
        var dates: [String] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date.asFormattedString())
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
}
