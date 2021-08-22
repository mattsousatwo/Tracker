//
//  Conversion.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/21/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation

class Conversion {
    let cal = Calendar.current
    let formatter = DateFormatter()
    
    // Get Bool value from Int
    var intToBool: (Int) -> Bool? = { (a) in
        if a == 0 {
            return false
        } else if a == 1 {
            return true
        }
        return nil
    }
    // Get Int value from Bool
    var boolToInt: (Bool) -> Int? = { (b) in
        if b == false {
            return 0
        } else if b == true {
            return 1
        }
        return nil
    }
    
    /// Convert String to Double 
    func convertToDouble(string: String) -> Double? {
        if string != "" {
            if let double = Double(string) {
                return double
            }
        }
        return nil
    }
    
    
    
    /// Convert date to MMM/d/yyyy - "Jun/12/2012"
    func formatDateToNormalStyle(_ date: Date) -> String? {
        let d  = cal.dateComponents([.month, .day, .year], from: date)
        if let newDate = cal.date(from: d) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM/d/yyyy"
            let s = formatter.string(from: newDate)
            return s
        }
        return nil
    }
    
    func convertDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        let format = "E, d MMM yyyy HH:mm:ss Z"
        formatter.dateFormat = format
        guard let date = formatter.date(from: dateString) else { return nil }
        return date
    }
    
    
    func historyRowFormat(_ dateString: String?) -> String? {
        guard let date = convertDate(dateString) else { return nil }
        let format = "MMM d, yyyy h:mm a"
        formatter.dateFormat = format
        let newDate = formatter.string(from: date)
        return newDate
    }

    // Convert a bool into FavoriteKey
    func convertToFavoriteKey(_ bool: Bool) -> FavoriteKey {
        switch bool {
        case true:
            return FavoriteKey.isFavorite
        case false:
            return FavoriteKey.notFavorite
        }
    }
    
}
