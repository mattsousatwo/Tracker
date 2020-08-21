//
//  Conversion.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/21/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation

class Conversion {
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
}
