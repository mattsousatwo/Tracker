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
    func getFrequencyOfBathroomUse() {
        
        bathroomBreak.fetchAll()
        if let entries = bathroomBreak.bathroomEntries {
            
//        d(e: entries)
            getAverageBathroomIncrement(of: entries)
        
            
//            for entry in entries {
//                print("RAW: \(entry.date)")
//                if let date = convertDate(entry.date) {
////                convertTime(entry.time)
//                getTimeComponents(from: date)
//                    getFromatted(date: date)
//                }
//                print("\n")
//            }
            
        }
    }
    
    // 
    
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

    
    // Need to find a way to only compare values within a time frame
    // - can put values from non matching days inside an array, then compare those values next - or reintroduce them after the conversion element has cycled through the list
    func getAverageBathroomIncrement(of entries: [BathroomEntry]) -> Int {
        guard entries.count > 3 else { return 0 }
        let convertedEntries = convertBathroomUsageTo(conversionElements: entries)
        let bathroomEntries = convertedEntries.sorted(by: { $0.date > $1.date })
        
        var usedEntries: Set<ConversionElement> = []
        var totalDifference = 0
        
        var lowerCount = 0
        var upperCount = bathroomEntries.count - 1
        var comparisonElement = bathroomEntries[lowerCount] // 0
        
        
        while usedEntries.contains(comparisonElement) == false && lowerCount < upperCount {
            
            usedEntries.insert(comparisonElement)
            lowerCount += 1
            
            while lowerCount < upperCount {
                let lowerDifference = comparisonElement.timeInMinutes() - bathroomEntries[lowerCount].timeInMinutes()
                totalDifference = totalDifference + lowerDifference
                lowerCount += 1
                
                let upperDifference = comparisonElement.timeInMinutes() - bathroomEntries[upperCount].timeInMinutes()
                totalDifference = totalDifference + upperDifference
                upperCount -= 1
            }
            
            lowerCount = 0 + usedEntries.count
            
            comparisonElement = bathroomEntries[lowerCount]
        }
        
        let average = totalDifference / usedEntries.count
        print("Average time between bathroom use: \(average) mins")
        
        return average
    }
    
    func sortEntriesByDay(_ entries: [ConversionElement]) -> [[ConversionElement]] {
        guard entries.count > 2 else { return [] }
        let elements = entries.sorted(by: { $0.date > $1.date })
        
        var allEntries: [[ConversionElement]] = []
        
        var currentDay: [ConversionElement] = []
        
        var currentElementIndex = 0
        
        while currentElementIndex + 1 < elements.count {
            currentDay.append(elements[currentElementIndex])
            let sameDay = compareIfDatesAreFromSameDay(elements[currentElementIndex].date, elements[currentElementIndex + 1].date)
            switch sameDay {
            case true:
                currentDay.append(elements[currentElementIndex + 1])
                currentElementIndex += 2
            case false:
                allEntries.append(currentDay)
                currentDay.removeAll()
                currentElementIndex += 1
            }
        }
        return allEntries
    }
    
    
}


// Creates an element used for converting Bathroom entries by time
class ConversionElement: Hashable {
    
    let uuid: String
    let timeValue: String
    var date: Date {
        if let date = convertToDate(timeValue) {
            return date
        }
        return Date()
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
