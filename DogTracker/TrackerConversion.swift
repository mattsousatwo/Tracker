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
    let cal = Calendar.current
    
    // Convert Bathroom use into frequency of time
    func getFrequencyOfBathroomUse() -> PredictionTime {
        
        bathroomBreak.fetchAll()
        guard let entries = bathroomBreak.bathroomEntries else { return PredictionTime(hours: 0, minutes: 0) }
//        return getAverageBathroomIncrement(of: entries)
        return findAverageBathroomInterval(of: entries)
    }
    
    
    
    func convertTime(_ timeString: String?) -> Date? {
        guard let timeString = timeString else { return nil }
        formatter.timeStyle = .short
        guard let time = formatter.date(from: timeString) else { return nil }
//        print("Time: \(time)")
        return time
    }

    func convertDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
//        let format = "MMM/d/yyyy"
        let format = "E, d MMM yyyy HH:mm:ss Z"
        formatter.dateFormat = format
        guard let date = formatter.date(from: dateString) else { return nil }
//        print("Date: \(date)")
        return date
    }
    
    func getTimeComponents(from date: Date) -> (hour: Int, min: Int) {
        let hour = cal.component(.hour, from: date)
        let min = cal.component(.minute, from: date)
        
//        print("\(hour): \(min)")
        return (hour: hour, min: min)
    }
    
    func getFromatted(date: Date)  {
        let d  = cal.dateComponents([.month, .day, .year], from: date)
        if let newDate = cal.date(from: d) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM/d/yyyy"
            let s = formatter.string(from: newDate)
            print(s)
        }
    }
    
    func compareIfDatesAreFromSameDay(_ one: Date, _ two: Date) -> Bool {
        let componentsOne = cal.dateComponents([.month, .day, .year], from: one)
        let componentsTwo = cal.dateComponents([.month, .day, .year], from: two)
        
        if componentsOne == componentsTwo {
            return true
        }
        return false
    }
    
    
    // Used to compare all the bathroom entries
    // Need to make it so that none of the bathroom entries are compared more than once
    func d(e: [BathroomEntry]) {
        
        let bEntries = convertBathroomUsageTo(conversionElements: e)
        let entries = bEntries.sorted(by: { $0.date > $1.date })
        var usedEntries: [String] = []
        
        var totals = [Int]()
        
        for index in 0..<entries.count {
            let x = usedEntries.contains(entries[index].uuid)
            if x != true {
                print(entries[index].date)
                
                
                totals.append(contentsOf:  compare(entry: entries[index], elements: entries))
                usedEntries.append(entries[index].uuid)
            }
        }
        
//        entries.map({ totals.append(contentsOf: compare(entry: $0, elements: entries)) })
        print("Totals \(totals)")
    }
    
    
    
    func compare(entry: ConversionElement, elements: [ConversionElement]) -> [Int] {
        print("\nElements Count: \(elements.count)\n")
        
        var totals = [Int]()
        
        for index in 0..<elements.count {
            
            if entry.uuid != elements[index].uuid {
                
                
                let fromSameDay = compareIfDatesAreFromSameDay(elements[index].date, entry.date)
                switch fromSameDay {
                case true:
                    
                    var dateOneInMinutes: Int {
                        
                        let time = getTimeComponents(from: elements[index].date)
                        
                        let hourToMins = time.hour * 60
                        let totalMinutes = hourToMins + time.min
                        return totalMinutes
                    }
                    
                    var dateTwoInMinutes: Int {
                        let time = getTimeComponents(from: entry.date)
                        
                        let hourToMins = time.hour * 60
                        let totalMinutes = hourToMins + time.min
                        return totalMinutes
                    }
                    
                    if dateOneInMinutes != dateTwoInMinutes {
                        
                        if dateOneInMinutes > dateTwoInMinutes {
                            print("Equation: (d1: \(dateOneInMinutes) - d2: \(dateTwoInMinutes))")
                            
                            let s = dateOneInMinutes - dateTwoInMinutes
                            print("minutesDiffrence: \(s)")
                            totals.append(s)
                        } else if dateOneInMinutes < dateTwoInMinutes {
                            print("Equation: (d2: \(dateTwoInMinutes) - d1: \(dateOneInMinutes))")
                            
                            let s =  dateTwoInMinutes - dateOneInMinutes
                            print("minutesDiffrence: \(s)")
                            totals.append(s)
                        }
                        

                    }
                case false:
                    print("false")
                }
 
            }
            
            
        }
        
        return totals
    }
    
    
    // Converts an array of BathroomEntry to ConversionElements
    private func convertBathroomUsageTo(conversionElements bathroomEntries: [BathroomEntry]) -> [ConversionElement] {
        var elements = [ConversionElement]()
        
        guard bathroomEntries.count > 0 else { return elements }
        
        var lowerCounter = 0
        var upperCounter = bathroomEntries.count - 1
        
        while lowerCounter < upperCounter {
            if let lowerID = bathroomEntries[lowerCounter].uid, let lowerDate = bathroomEntries[lowerCounter].date {
                let lowerElement = ConversionElement(uuid: lowerID, timeValue: lowerDate)
                elements.append(lowerElement)
                lowerCounter += 1
            }
            if let upperID = bathroomEntries[upperCounter].uid, let upperDate = bathroomEntries[upperCounter].date {
                let upperElement = ConversionElement(uuid: upperID, timeValue: upperDate)
                elements.append(upperElement)
                upperCounter -= 1
            }
        }
        
        return elements
    }

    // Use the time to indicate night into next day
    // need to determine when an overdue time was indicated and then an entry was added
    // Some values are getting counted twice as seperate day values - days will have the comparison element twice, and the other values that match the day
    func getAverageBathroomIncrement(of entries: [BathroomEntry]) -> Int {
        guard entries.count > 3 else { return 0 }
        let convertedEntries = convertBathroomUsageTo(conversionElements: entries)
//        let bathroomEntries = convertedEntries.sorted(by: { $0.date > $1.date })
        
        let bathroomEntries = sortEntriesByDay(convertedEntries)
        print("T1 - entries count: \(bathroomEntries.count)")
        var usedEntries: Set<ConversionElement> = []
        var totalDifference = 0
        
        for day in bathroomEntries {
            print("T1 - day count: \(day.count)")
            for day in day {
                print("T1 - entry time: \(day.timeValue)")
            }
            print("T1 - ----------\n")
            if day.count > 0 {
                var lowerCount = 0
                var upperCount = day.count - 1
                var comparisonElement = day[lowerCount] // 0
                
                while usedEntries.contains(comparisonElement) == false && lowerCount < upperCount {
                    
                    usedEntries.insert(comparisonElement)
                    lowerCount += 1 // MARK: 1
                    
                    while lowerCount < upperCount {
                        let lowerDifference = comparisonElement.timeInMinutes() - day[lowerCount].timeInMinutes()
                        totalDifference = totalDifference + lowerDifference
                        lowerCount += 1
                        
                        let upperDifference = comparisonElement.timeInMinutes() - day[upperCount].timeInMinutes()
                        totalDifference = totalDifference + upperDifference
                        upperCount -= 1
                    }
                    
                    lowerCount = 0 + usedEntries.count
                    comparisonElement = day[lowerCount]
                }
            }
            
        }
        
        var average = 0
        
        if usedEntries.count != 0 {
            average = totalDifference / usedEntries.count
        }
        print("T1 - totalDifference(\(totalDifference)) / usedEntries(\(usedEntries.count))")
        print("T1 - Average time between bathroom use: \(average) mins")
        print("T1 - ------------------------------------------------------------------------\n")
        
        return average
    }
    
    
    
    /// Find the average difference between the entreries in the array
    func findAverageBathroomInterval(of entries:[BathroomEntry]) -> PredictionTime {

        let convertedElements = convertBathroomUsageTo(conversionElements: entries)
        let bathroomEntries = sortEntriesByDay(convertedElements)
        
        // Find the average difference beteen days
        func findAverageInterval(for entryArray: [ConversionElement]) -> Int? {
            guard entryArray.count > 1 else { return nil }
            let sortedArray = entryArray.sorted(by: {$0.date > $1.date})
            
            var differenceArray: [Int] = []
            
            var indexOne = 0
            var indexTwo = 0
            
            while indexOne <= sortedArray.count - 1 {
                
                if indexOne == sortedArray.count - 1 {
                    break
                } else {
                    indexTwo = indexOne + 1
                    
                    let elementOne = sortedArray[indexOne]
                    let elementTwo = sortedArray[indexTwo]
                    
                    let timeDifference = elementOne.timeInMinutes() - elementTwo.timeInMinutes()
                    if timeDifference > 0 {
                        differenceArray.append(timeDifference)
                    }
                    
                    indexOne += 1
                    
                }
                
                
            }
            
            var total = 0
            for element in differenceArray {
                total += element
            }
            
            if total > 0 {
                return total / differenceArray.count
            }
        
            return 0
        }
        
            var dailyAverages = 0
            var totalAverage = 0
        
        var multipleEntryDays = [[ConversionElement]]()
        
        for day in bathroomEntries {
            if day.count > 1 {
                multipleEntryDays.append(day)
                if let average = findAverageInterval(for: day) {
                    dailyAverages += average
                }
            }
        }
        
        if dailyAverages > 0 {
            totalAverage = dailyAverages / multipleEntryDays.count
        }

//        return totalAverage
        let hours = totalAverage / 60
        let minutes = totalAverage % 60
        
        return PredictionTime(hours: hours,
                              minutes: minutes)
    }

    
   
    
    
    
    
    
    
    
    
    
    
    func sortEntriesByDay(_ entries: [ConversionElement]) -> [[ConversionElement]] {
        guard entries.count > 1 else { return [entries] }
        let elements = entries.sorted(by: { $0.date < $1.date })
        
        var usedEntries: Set<ConversionElement> = []
        var allEntries: [[ConversionElement]] = []
        var currentDay: [ConversionElement] = []
   
        func compareEntries(to entry: ConversionElement) -> [ConversionElement] {
            
            var currentDay: [ConversionElement] = []
            
            var index: Int = 0
            
            usedEntries.insert(entry)
            currentDay.append(entry)
            
            while index < elements.count {
                switch usedEntries.contains(elements[index]) {
                case true:
                    index += 1
                case false:
                    if entry.isFromTheSameDay(as: elements[index]) {
                        usedEntries.insert(elements[index])
                        currentDay.append(elements[index])
                        index += 1
                    } else {
                        return currentDay
                    }
                    
                }
                
            }
            
            return currentDay
        }
        
        for entry in elements {
            if usedEntries.contains(entry) == false {
                currentDay = compareEntries(to: entry)
                if currentDay.count > 0 {
                    allEntries.append(currentDay)
                    currentDay.removeAll()
                }
            }
        }
        
        return allEntries
    }
    
    
    
    
    
}


// Creates an element used for converting Bathroom entries by time
class ConversionElement: Hashable {
    private let cal = Calendar.current
    let uuid: String
    let timeValue: String
    var date: Date {
        if let date = convertToDate(timeValue) {
            return date
        }
        return Date()
    }
    var dayValue: Int {
        return cal.component(.day, from: date)
    }
    var monthValue: Int {
        return cal.component(.month, from: date)
    }
    var yearValue: Int {
        return cal.component(.year, from: date)
    }
     
    init(uuid: String, timeValue: String) {
        self.uuid = uuid
        self.timeValue = timeValue
        
    }
    
    func convertToDate(_ dateString: String?) -> Date? {
        let formatter = DateFormatter()
        guard let dateString = dateString else { return nil }
//        let format = "MMM/d/yyyy"
        let format = "E, d MMM yyyy HH:mm:ss Z"
        formatter.dateFormat = format
        guard let date = formatter.date(from: dateString) else { return nil }
//        print("Date: \(date)")
        return date
    }
    
    func isFromTheSameDay(as element: ConversionElement) -> Bool {
        return self.dayValue == element.dayValue &&
            self.monthValue == element.monthValue &&
            self.yearValue == element.yearValue
        
    }
    
    
    func timeInMinutes() -> Int {
        let time = getTimeComponents(from: date)
        let hoursInMinutes = time.hour * 60
        return hoursInMinutes + time.min
    }
    
    
    func getTimeComponents(from date: Date) -> (hour: Int, min: Int) {
        let cal = Calendar.current
        
        let hour = cal.component(.hour, from: date)
        let min = cal.component(.minute, from: date)
        
//        print("\(hour): \(min)")
        return (hour: hour, min: min)
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func ==(lhs: ConversionElement, rhs: ConversionElement) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
