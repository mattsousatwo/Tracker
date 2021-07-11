//
//  Color+EXT.swift
//  ActivityRing
//
//  Created by Matthew Sousa on 8/29/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

extension Color {
    
    public init(red: Int, green: Int, blue: Int, opacity: Double = 1.0) {
        
        let redVal = Double(red) / 255.0
        let grnVal = Double(green) / 255.0
        let bluVal = Double(blue) / 255.0
        
        self.init(red: redVal, green: grnVal, blue: bluVal, opacity: opacity)
        
        
    }
//    rgba(242,242,248,255)
    
    public static let backgroundGray = Color(red: 242, green: 242, blue: 248)
    public static let textGrey = Color(red: 208, green: 198, blue: 193)
    public static let dRed = Color(red: 231, green: 124, blue: 77)
    public static let lRed = Color(red: 252, green: 238, blue: 231)
    public static let dBlue = Color(red: 165, green: 209, blue: 228)
    public static let lBlue = Color(red: 236, green: 246, blue: 249)
    public static let dYellow = Color(red: 248, green: 215, blue: 122)
    public static let lYellow = Color(red: 254, green: 247, blue: 227)
    
    
    
    public static let lightRed = Color(red: 231, green: 76, blue: 60)
    
    public static let darkRed = Color(red: 192, green: 57, blue: 43)
    
    public static let lightGreen = Color(red: 46, green: 204, blue: 96)
    
    public static let darkGreen = Color(red: 39, green: 174, blue: 96)
    
    public static let lightPurple = Color(red: 155, green: 89, blue: 182)
    
    public static let darkPurple = Color(red: 142, green: 68, blue: 173)
    
    public static let lightBlue = Color(red: 52, green: 152, blue: 219)
    
    public static let darkBlue = Color(red: 41, green: 128, blue: 185)
    
    public static let lightYellow = Color(red: 241, green: 196, blue: 15)
    
    public static let darkYellow = Color(red: 243, green: 156, blue: 18)
    
    public static let lightOrange = Color(red: 230, green: 126, blue: 34)
    
    public static let darkOrange = Color(red: 211, green: 84, blue: 0)
    
    public static let purpleBG = Color(red: 69, green: 51, blue: 201)
    
    
} // Color

