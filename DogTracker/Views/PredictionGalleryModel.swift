//
//  PredictionGalleryModel.swift
//  DogTracker
//
//  Created by Matthew Sousa on 2/7/22.
//  Copyright © 2022 Matthew Sousa. All rights reserved.
//

import Foundation

class PredictionGalleryModel: TrackerConversion, ObservableObject {
    
    var bathroomPhrase: BathroomPhrase = .lavatory
    
    /// On appear of Prediction Gallery this function will run to update the views properties
    func calculatePredictionRate(of dog: Dog) -> PredictionGalleryState {
        var predictionState: PredictionGalleryState = .calculating
        
        if dog.uuid == "" {
            predictionState = .failed(reason: "DogID == nil ")
            return predictionState
        }
        
        // determine time based on age
        let defaultTime = calculateDefaultPredictionTime(for: dog)
        
        
            // 1. get average interval of bathrom use
        var intervalTime = self.getFrequencyOfBathroomUse(for: dog.uuid)
            
//        if intervalTime.isLessThan(defaultTime) {
//            intervalTime = defaultTime
//        }
         
            // 2. Check if PredictionTime is under an Hour and 10 mins
            if intervalTime.countdownTime.hours < 1 && intervalTime.countdownTime.minutes < 10 {
                
                // 2. a) Not enough data
//                predictionState = .notEnoughData(reason: "not enough data collected")
                predictionState = .success(time: defaultTime)
                print("t3 - \(predictionState.asString()): -- IntervalTime -- \(intervalTime)")
                
            } else {
                
                // 2. b) Success - add time
                predictionState = .success(time: intervalTime)
                print("\t3 - \(predictionState.asString()): -- IntervalTime --  \(intervalTime)")
            }
            
            self.bathroomPhrase = self.bathroomPhrase.randomizePhrase()
        
        return predictionState
    }
    
    
    func calculateDefaultPredictionTime(for dog: Dog) -> PredictionTime {
        let time = PredictionTime(hours: 0, minutes: 0)
        if dog.age.years > 0 {
            time.add(hours: 8)
        } else {
            switch dog.age.months {
            case 1, 2:
                time.add(hours: 2)
            case 3:
                time.add(hours: 4)
            case 4:
                time.add(hours: 5)
            case 5, 6:
                time.add(hours: 6)
            case 7, 8, 9, 10, 11, 12:
                time.add(hours: 8)
            default:
                break
            }
        }
        return time
    }

    /// Calculate the time the bathroom prediction is leading up to
    func calculateCountdownTime(_ intervalTime: (hours: Int, minutes: Int)) -> String {
        let date = Date()
        let cal = Calendar.current
        guard let dateWithUpdatedHour = cal.date(byAdding: .hour,
                                                 value: intervalTime.hours,
                                                 to: date),
              let finalDate = cal.date(byAdding: .minute,
                                       value: intervalTime.minutes,
                                       to: dateWithUpdatedHour) else { return "Failed Conversion" }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let formattedDate = formatter.string(from: finalDate)
        return formattedDate
    }
    
    
    func countdownTimerString(_ state: PredictionGalleryState) -> String {
        return state.asString()
    }
    
    func titleString() -> String {
        return "Your dog will need to use the \(bathroomPhrase.randomizePhrase().rawValue) in: "

    }
    
    /// Check if one minute has passed to countdown the timer
    func checkIfOneMinuteHasPassed(_ time: Date) -> (time: Date?, hasPassed: Bool) {
        let cal = Calendar.current
        let newTime = Date()
        
        let currentTimeMinutes = cal.component(.minute, from: time)
        let newTimeMinutes = cal.component(.minute, from: newTime)
        
        if currentTimeMinutes != newTimeMinutes  {
            return (time: newTime, hasPassed: true)
        } else {
            return (time: nil, hasPassed: false)
        }
        
    }
    
    // Compare current time to the date saved, if one minute has passed since the saved time has been initialized, decrement time
    func decrementCountdown(_ state: PredictionGalleryState) -> PredictionGalleryState? {
        switch state {
        case .success(let time):
            
            var minutes = time.countdownTime.minutes
            var hours = time.countdownTime.hours
 
            if minutes > 0 {
                minutes -= 1
            } else if minutes == 0 {
                if hours > 0 {
                    hours -= 1
                    minutes = 59
                } else if hours == 0 && minutes == 0 {
                    return .overdue
                }
            }
            
            let newTime = PredictionTime(hours: hours,
                                         minutes: minutes)
            return .success(time: newTime)
        default:
            return nil 
        }
        
    }
    
    enum BathroomPhrase: String, CaseIterable {
        case lavatory = "lavatory"
        case powderRoom = "powder room"
        case restroom = "restroom"
        case washroom = "washroom"
        case facilities = "facilities"
        
        func randomizePhrase() -> BathroomPhrase {
            let randomIndex = Int.random(in: 0..<BathroomPhrase.allCases.count)
            return BathroomPhrase.allCases[randomIndex]
        }
    }
    
}

class PredictionTime: Equatable {
    static func == (lhs: PredictionTime, rhs: PredictionTime) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    private let uuid = UUID().uuidString
    var countdownTime: (hours: Int, minutes: Int)
    var estimatedTime: String = ""
    
    init(hours: Int, minutes: Int) {
        self.countdownTime.hours = hours
        self.countdownTime.minutes = minutes
        
        self.estimatedTime = calculateCountdownTime()
    }
    
    /// Calculate the time the bathroom prediction is leading up to
    private func calculateCountdownTime() -> String {
        let date = Date()
        let cal = Calendar.current
        guard let dateWithUpdatedHour = cal.date(byAdding: .hour,
                                                 value: countdownTime.hours,
                                                 to: date),
              let finalDate = cal.date(byAdding: .minute,
                                       value: countdownTime.minutes,
                                       to: dateWithUpdatedHour) else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let formattedDate = formatter.string(from: finalDate)
        return formattedDate
    }
    
    func add(hours: Int, minutes: Int = 0) {
        countdownTime.hours += hours
        
        if minutes >= 60 {
            let hours = minutes / 60
            let leftoverMinutes = minutes % 60
            
            countdownTime.hours += hours
            countdownTime.minutes += leftoverMinutes
        }
   
    }
    
    func isGreaterThan(_ comparisonTime: PredictionTime) -> Bool {
        if self.countdownTime.hours >= comparisonTime.countdownTime.hours {
            if self.countdownTime.hours > comparisonTime.countdownTime.hours {
                return true
            } else {
                if comparisonTime.countdownTime.minutes > self.countdownTime.minutes {
                    return true
                }
            }
        }
        return false
    }
    
    func isLessThan(_ comparisonTime: PredictionTime) -> Bool {
        return !isGreaterThan(comparisonTime)
    }
}


