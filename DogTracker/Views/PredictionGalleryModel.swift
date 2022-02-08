//
//  PredictionGalleryModel.swift
//  DogTracker
//
//  Created by Matthew Sousa on 2/7/22.
//  Copyright © 2022 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI

struct PredictionGalleryModel {
    let trackerConversion = TrackerConversion()
    
    @State var bathroomPhrase: BathroomPhrase = .lavatory
    
    /// On appear of Prediction Gallery this function will run to update the views properties
    func onAppear() -> PredictionGalleryState {
        
        let intervalTime = trackerConversion.getFrequencyOfBathroomUse()
        
        
        
        var predictionState: PredictionGalleryState = .initalizing
        if intervalTime == PredictionTime(hours: 0, minutes: 0) || intervalTime.countdownTime.hours < 1 && intervalTime.countdownTime.minutes < 10 {
            predictionState = .notEnoughData
            print("t3 - \(predictionState.asString()): -- IntervalTime -- \(intervalTime)")
        } else {
            predictionState = .success(time: intervalTime)
            print("\t3 - \(predictionState.asString()): -- IntervalTime --  \(intervalTime)")
        }
        
        
        
        
        bathroomPhrase = bathroomPhrase.randomizePhrase()
        return predictionState
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

struct PredictionTime: Equatable {
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
}


