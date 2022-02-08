//
//  PredictionGalleryState.swift
//  DogTracker
//
//  Created by Matthew Sousa on 2/7/22.
//  Copyright © 2022 Matthew Sousa. All rights reserved.
//

import Foundation

enum PredictionGalleryState: Equatable {
    case initalizing
    case calculating
    case success(time: PredictionTime)
    case failed
    case notEnoughData
    case overdue
    
    func asString(time: PredictionTime? = nil) -> String {
        switch self {
        case .initalizing:
            return ""
        case .calculating:
            return "Calculating..."
        case .success(let time):
            return "\(time.countdownTime.hours):\(time.countdownTime.minutes)"
        case .failed:
            return "Failed Load"
        case .notEnoughData:
            return "Not enough data collected"
        case .overdue:
            return "Overdue"
        }
    }
}
