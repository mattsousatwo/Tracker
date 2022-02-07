//
//  TrackerConversionTests.swift
//  DogTrackerTests
//
//  Created by Matthew Sousa on 2/4/22.
//  Copyright © 2022 Matthew Sousa. All rights reserved.
//

import XCTest
@testable import DogTracker

class TrackerConversionTests: XCTestCase {

    let trackerConversion = TrackerConversion()
    
    func testBathroomIntervalAlgorithm() {
        let frequency = trackerConversion.getFrequencyOfBathroomUse()
        XCTAssert(frequency > 0, "Frequency is equal to 0")
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
