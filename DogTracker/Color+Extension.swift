//
//  Color+Extension.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/29/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

extension View {
    
    public static var darkBlue: Color {
        return Color("DarkSlateBlue")
    }
    
    public static var slateBlue: Color {
        return Color("SlateBlue")
    }
    
    public static var androidGreen: Color {
        return Color("AndroidGreen")
    }
    

    public static var azure: Color {
        return Color("Azure")
    }
    
    public static var backgroundGray: Color {
        return Color("LairBackgroundGray")
    }
    
    
    
    
    // Gradient Arrays
    public static var gradientOne: Gradient {
        return Gradient(colors: [Color.lightPurple, Color.purple])
    }
    
    public static var gradientTwo: Gradient {
        return Gradient(colors: [Color.lightGreen, Color.darkGreen])
    }
    
    public static var gradientThree: Gradient {
        return Gradient(colors: [Color.lightRed, Color.darkRed])
    }
    
}
