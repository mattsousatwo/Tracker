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
            
 d(e: entries)
            
            
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
    
    func d(e: [BathroomEntry]) {
        
        let bEntries = convertBathroomUsageTo(conversionElements: e)
        var entries = bEntries.sorted(by: { $0.date > $1.date })
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
                            print("Equation: (d2: \(dateTwoInMinutes) - d1: \(dateOneInMinutes))")
                            
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
    
    private func convertBathroomUsageTo(conversionElements bathroomEntries: [BathroomEntry]) -> [ConversionElement] {
        var elements = [ConversionElement]()
        
        for entry in bathroomEntries {
            if let id = entry.uid, let date = entry.date {
                let element = ConversionElement(uuid: id, timeValue: date)
                elements.append(element)
            }
        }
        return elements
    }
    
}



class ConversionElement {
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
}
