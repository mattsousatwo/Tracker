//
//  DogTrackerTests.swift
//  DogTrackerTests
//
//  Created by Matthew Sousa on 8/10/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import XCTest
@testable import DogTracker
import Alamofire


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
    
    /// Test if generic Delete all will work with BathroomBreak
    func testIfDeleteBathroomEntriesWorks() {
        let bathroom = BathroomBreak()
        bathroom.deleteAll(.bathroomBreak)
        
        bathroom.fetchAll()
        XCTAssertEqual(bathroom.bathroomEntries?.count, 0)
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

class DogTests: XCTestCase {
    
    
    
    /// Testing to see if saving inside Dogs class will work
    func testIfSavingDogWillWork() {
        let dogs = Dogs()
        dogs.fetchAll()
        let initalDogsCount = dogs.allDogs.count

        let _ = dogs.createNewDog(name: "MattsDog")
        
        dogs.fetchAll()
        XCTAssertEqual(dogs.allDogs.count, (initalDogsCount + 1))
        
    }
    
    /// Test if delete is working
    func testIfDeleteAllDogsWorks() {
        let dogs = Dogs()
        dogs.deleteAll(.dog)
        
        dogs.fetchAll()
        XCTAssertEqual(dogs.allDogs.count, 0)
    }
    
    
    /// Create Test Dogs
//    func testCreateDogs() {
//
//        let dogs = Dogs()
//
//        let _ = dogs.createNewDog(name: "Tito", breed: "Pomeranian")
//        let _ = dogs.createNewDog(name: "Rosie", breed: "Mini Goldendoodle")
//        let _ = dogs.createNewDog(name: "Bandit", breed: "Padderdale-Terrier")
//        let _ = dogs.createNewDog(name: "Tessa", breed: "Padderdale-Terrier")
//
//        dogs.fetchAll()
//        XCTAssertEqual(dogs.allDogs.count, 4)
//    }
    
//    /// Test if fetching favorite dog works
//    func testFavoriteDogFetching() {
//        let dogs = Dogs()
//
//        let favoriteDog = dogs.createNewDog(name: "Apa",
//                                            breed: "Flying Bison",
//                                            uuid: "12345",
//                                            weight: 20.0,
//                                            birthdate: "12/23/42",
//                                            isFavorite: true)
//
//        let fetchedDog = dogs.fetchFavoriteDog()
//
//        XCTAssertEqual(favoriteDog, fetchedDog)
//
//        dogs.deleteSpecificElement(.dog, id: favoriteDog!.uuid)
//
//    }
    
    func testEncodingAndDecodingOfBreeds() {
        let dogs = Dogs()
        
        let dogBreeds = ["Pomeranian", "German Shepard", "Pitbull"]
        
        guard let breeds = dogs.encode(breeds: dogBreeds) else { return }
        
        guard let decodedBreeds = dogs.decode(breeds: breeds) else { return }
        
        XCTAssertTrue(dogBreeds == decodedBreeds)
    }
    
}

class BreedTests: XCTestCase {
    
    var breeds = Breeds()
    var dogNames = BreedList()
    
    
    /// Test if saving all dog breeds will work
    func testIfSavingAllBreedNamesWorks() {
        
        for breed in dogNames.allDogBreeds {
            breeds.createNew(breed: breed.name)
        }
        
        breeds.fetchAll()
        
        print("\nDog Breed Names Count: \(dogNames.allDogBreeds.count)\n")
        
    }
    
    
    
}

class BathroomBreakTests: XCTestCase {
    
    let bathroomBreak = BathroomBreak()
    let anotherDogID = "HBU7X"
    
    func testFetchingEntriesForDog() {
        let entries = bathroomBreak.fetchAllEntries(for: anotherDogID)
        
        XCTAssertTrue(entries?.count != 0  , "Entries.count == \(entries?.count )")
    }
    
    func testGettingDatesInWeek() {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        let today = calendar.startOfDay(for: Date() )
        let dayOfTheWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound )
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfTheWeek, to: today)}
//            .filter { !calendar.isDateInWeekend($0) }
        
        print("\n \(days)")
        
        let formatter = DateFormatter()
        print("\(formatter.graphDateFormat(days.first!)) - \(formatter.graphDateFormat(days.last!)) ")
    }
    
    
    func testGettingEntriesOfType() {
        let _ = bathroomBreak.createNewEntry(dogUUID: anotherDogID, time: Date(), type: .vomit)
        
        let entries = bathroomBreak.fetchAllEntries(for: anotherDogID, ofType: .vomit)
        
        print("Entries.count == \(entries?.count )")
        XCTAssertTrue(entries?.count != 0  , "Entries.count == \(entries?.count )")
        
    }
    
    
    
    
}
