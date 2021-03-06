//
//  DogTrackerTests.swift
//  DogTrackerTests
//
//  Created by Matthew Sousa on 8/10/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import XCTest
@testable import DogTracker

class DogTrackerTests: XCTestCase {

    
    func testIfSaveBathroomEntriesIsWorking() {
        let b = BathroomBreak()
        let entry = b.createNewEntry()
        
        // Find SQL Database
        let URLS = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(URLS[URLS.count-1] as URL)
        
        if entry == nil {
            XCTAssert(false)
        } else {
            XCTAssert(true)
        }
       
    }


}

class DateTests: XCTestCase {
    
    
    /// Test to see if timeFormat will be able to handle whitespace charater from Date variables EX: 13:42 = 1:42 AM || 09:24 = 9:24 PM
    func testTwelveHourFormatter() {
        let cal = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()
        
        var dateComponents = DateComponents()
        dateComponents.year = 2020
        dateComponents.month = 6
        dateComponents.day = 12
        dateComponents.hour = 8
        dateComponents.minute = 42
        
        let date = cal.date(from: dateComponents)!
        let time = formatter.twelveHourFormat(date)
        
        print("\nTime = \(time)\n")
        XCTAssertEqual(time, "8:42 AM")
        
    }
    
    
    /// Test to see if dateFormat is working properly
    func testDateFormat() {
        let cal = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()
        
        var dateComponents = DateComponents()
        dateComponents.year = 1992
        dateComponents.month = 11
        dateComponents.day = 16
        
        let date = cal.date(from: dateComponents)!
        let birthday = formatter.dateFormat(date)
        
        XCTAssertEqual(birthday, "Nov 16, 1992")
    }
}
