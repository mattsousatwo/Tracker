//
//  Int+EXT.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/5/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

extension Int {
    
    /// Convert any hour over 12 to a 12 hour clock digit. Example: 14.convertToTweleveHourClock() = 2
    func convertToTwelveHourClock() -> Int {
        if self >= 13 && self <= 24 {
            switch self {
            case 13:
                return 1
            case 14:
                return 2
            case 15:
                return 3
            case 16:
                return 4
            case 17:
                return 5
            case 18:
                return 6
            case 19:
                return 7
            case 20:
                return 8
            case 21:
                return 9
            case 22:
                return 10
            case 23:
                return 11
            case 24:
                return 12
            default:
                return self
            }
        } else {
            return self
        }
    }
    
}
