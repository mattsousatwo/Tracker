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
    case failed(reason: String? = nil)
    case notEnoughData(reason: String? = nil)
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
        case .notEnoughData(let reason):
            if let reason = reason {
                return "Not enough data collected - \(reason)"
            } else {
                return "Not enough data collected"
            }
        case .overdue:
            return "Overdue"
        }
    }
    
    /// Return the prediction time associated with the success case if avalible 
    func predictionTime() -> PredictionTime? {
        switch self {
        case .success(let time):
            return time
        default:
            return nil
        }
    }
}
