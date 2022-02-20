//
//  Dog+CoreDataClass.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Dog)
public class Dog: NSManagedObject {

    let dogs = Dogs()
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let formatter = DateFormatter()
    let cal = Calendar.current
    
    /// Update properties for self
    func update(name: String? = nil,
                weight: Double? = nil,
                breed: [String]? = nil,
                birthdate: Date? = nil,
                isFavorite: FavoriteKey? = nil,
                image: UIImage? = nil) {
        
        if let name = name {
            self.name = name
        }
        if let weight = weight {
            self.weight = weight
        }
        if let breed = breed {
            self.encode(breeds: breed)
        }
        if let birthdate = birthdate {
            
            formatter.dateFormat = "yyyy/MM/dd"
            let convertedDate = formatter.string(from: birthdate)
            print("\n - saved birthday: \(convertedDate)\n")
            
            
            self.birthdate = convertedDate
            
        }
        if let isFavorite = isFavorite {
            self.isFavorite = isFavorite.rawValue
        }
        
        if let image = image {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                self.image = imageData
            }
        }
        
        if self.hasChanges == true {
            dogs.saveSelectedContext()
        }
    }
    
    
    var age: String {
        
        guard let birthdateString = self.birthdate else { return "nil" }
        
        formatter.dateFormat = "yyyy/MM/dd"
        guard let birthdate = formatter.date(from: birthdateString) else { return "nil" }
        
        let today = Date()
        
        func componentsOf(_ date: Date) -> (year: Int, month: Int, day: Int) {
            return (year: cal.component(.year, from: date),
                    month: cal.component(.month, from: date),
                    day: cal.component(.day, from: date))
        }
        
        let todaysComponents = componentsOf(today)
        let birthdatesComponents = componentsOf(birthdate)
        
        func isOlderThanOneYearOld() -> Bool {
            if todaysComponents.year > birthdatesComponents.year &&
                todaysComponents.month >= birthdatesComponents.month &&
                todaysComponents.day >= birthdatesComponents.day {
                return true
            }
            return false
        }
        
        
        
        
        switch isOlderThanOneYearOld() {
        case false:
            // check if in same year
            switch todaysComponents.year == birthdatesComponents.year {
            case true:
                let months = todaysComponents.month - birthdatesComponents.month
                if months > 1 {
                    return "\(months) months"
                } else if months == 1 {
                    return "\(months) month"
                } else if months < 1 {
                    let days = todaysComponents.day - birthdatesComponents.day
                    if days == 0 {
                        return "Newborn"
                    } else {
                        return "\(days) days"
                    }
                }
            case false:
                // Less than 1 year old
                // Todays date is in next year
                // calc month difference when one date is in the next year
                if let birthMonth = Month(birthdatesComponents.month) {
                    return "\(birthMonth.differenceBetween(todaysComponents.month)) months"
                }
            }
        case true:
            let age = todaysComponents.year - birthdatesComponents.year
            return "\(age)"
        }
        return ""
    }
    
    /// Transform image data to UIImage 
    func convertImage() -> UIImage? {
        if let imageData = image {
            if let convertedImage = UIImage(data: imageData) {
                return convertedImage
            }
        }
        return nil
    }
    
    func encode(breeds: [String]) {
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(breeds) else { return }
        self.breed = String(data: data, encoding: .utf8)
        if self.hasChanges == true {
            dogs.saveSelectedContext()
        }
    }
    
    func decodeBreeds() -> [String]? {
        guard let breeds = self.breed else { return nil }
        guard let data = breeds.data(using: .utf8) else { return nil }
        guard let selectedBreeds = try? decoder.decode([String].self, from: data) else { return nil }
        return selectedBreeds
    }

    
    
}

enum Month: Int {
    
    init?(_ input: Int) {
        switch input {
        case 1:
            self = .january
        case 2:
            self = .febuary
        case 3:
            self = .march
        case 4:
            self = .april
        case 5:
            self = .may
        case 6:
            self = .june
        case 7:
            self = .july
        case 8:
            self = .august
        case 9:
            self = .september
        case 10:
            self = .october
        case 11:
            self = .november
        case 12:
            self = .december
        default:
            self = .january
        }
    }
    
    case january = 1, febuary, march, april, may, june, july, august, september, october, november, december
    
    /// returns the next Month
    var next: Month {
        switch self {
        case .january:
            return .febuary
        case .febuary:
            return .march
        case .march:
            return .april
        case .april:
            return .may
        case .may:
            return .june
        case .june:
            return .july
        case .july:
            return .august
        case .august:
            return .september
        case .september:
            return .october
        case .october:
            return .november
        case .november:
            return .december
        case .december:
            return .january
        }
    }
    
    /// Converts an Int to Month
    func convertToMonth(_ num: Int) -> Month {
        if num < 1 {
            return .january
        } else {
            switch num {
            case 1:
                return  .january
            case 2:
                return .febuary
            case 3:
                return .march
            case 4:
                return .april
            case 5:
                return .may
            case 6:
                return .june
            case 7:
                return .july
            case 8:
                return .august
            case 9:
                return .september
            case 10:
                return .october
            case 11:
                return .november
            case 12:
                return .december
            default:
                return .december
            }
        }
    }
    
    /// Returns the amount of months that have passed this month to reach the input month - within a year
    func differenceBetween(_ inputMonth: Int) -> Int {
        
        let targetMonth = convertToMonth(inputMonth)
        
        if targetMonth == self {
            return 0
        } else {
            if targetMonth.rawValue > self.rawValue {
                return targetMonth.rawValue - self.rawValue
            } else {
                var count = 0
                var indexMonth = self.next
                var targetFound = false
                
                while targetFound == false {
                    if indexMonth != targetMonth {
                        count += 1
                        indexMonth = indexMonth.next
                    } else {
                        count += 1
                        targetFound = true 
                    }
                }
                return count
            }
        }
        
    }
}


