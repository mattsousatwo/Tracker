//
//  Age.swift
//  DogTracker
//
//  Created by Matthew Sousa on 2/19/22.
//  Copyright © 2022 Matthew Sousa. All rights reserved.
//

import Foundation


struct Age: Equatable, Hashable {
    
    private let formatter = DateFormatter()
    private let cal = Calendar.current
    
    var years: Int = 0
    var months: Int = 0
    var days: Int = 0
    
    var description: String {
        let years = "years"
        let year = "year"
        let month = "month"
        let months = "months"
        let day = "day"
        let days = "days"
        
        var desc = ""
        func updateDescription(to numberOfUnits: Int, with string: String) {
            desc = "\(numberOfUnits) \(string)"
        }
        if self.years == 0 {
            if self.months == 0 {
                switch self.days {
                case 1:
                    updateDescription(to: self.days, with: day)
                default:
                    updateDescription(to: self.days, with: days)
                }
            } else {
                switch self.months {
                case 1:
                    updateDescription(to: self.months, with: month)
                default:
                    updateDescription(to: self.months, with: months)
                }
            }
        } else {
            switch self.years {
            case 1:
                updateDescription(to: self.years, with: year)
            default:
                updateDescription(to: self.years, with: years)
            }
        }
        return desc
    }
}

extension Age {
    
    init(_ years: Int) {
        self.years = years
    }
    
    init(_ years: Int, _ months: Int, _ days: Int) {
        self.years = years
        self.months = months
        self.days = days
    }
    
    init(of dog: Dog) {
        let dogsAge = calculateAge(of: dog)
        self.years = dogsAge.years
        self.months = dogsAge.months
        self.days = dogsAge.days
    }
    
}

extension Age {
    
    /// return the date components of a Date
    func componentsOf(_ date: Date) -> (year: Int, month: Int, day: Int) {
        return (year: cal.component(.year, from: date),
                month: cal.component(.month, from: date),
                day: cal.component(.day, from: date))
    }

    /// Check if dogs birthday has passed
    func birthdateHasPassed(_ date: Date) -> Bool {
        let birthday = componentsOf(date)
        let today = componentsOf(Date())
        
        if today.month == birthday.month {
            if today.day <= birthday.day {
                return true
            }
        }
        
        return false
    }
    
    
    func calculateAge(of dog: Dog) -> Age {
        var age = Age(0)
        guard let birthdateString = dog.birthdate else { return age }
        
        formatter.dateFormat = "yyyy/MM/dd"
        guard let birthdate = formatter.date(from: birthdateString) else { return age }
        
        let birthComponets = componentsOf(birthdate)
        let currentComponents = componentsOf(Date())
        var daysCount = 0
        
        // Months
        guard let birthMonth = Month(birthComponets.month) else { return age }
        age.months = birthMonth.differenceBetween(currentComponents.month)

        // Days
        /// Calculate the number of days in the current year the dog has lived
        daysCount = birthMonth.countOfDaysFromToday(and: birthComponets.day)
        if daysCount >= 365 {
            let difference = daysCount - 365
            daysCount = difference
            age.days = difference
            age.years += 1
        }
        
        // Years
        if birthdateHasPassed(birthdate) == true {
            age.years = currentComponents.year - birthComponets.year
        } else {
            var dogYears = currentComponents.year - birthComponets.year
            dogYears -= 1
            age.years = age.years + dogYears
        }
        return age
    }
    
}
