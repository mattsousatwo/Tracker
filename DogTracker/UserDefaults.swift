//
//  UserDefaults.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/27/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

class UserDefaults: CoreDataHandler, ObservableObject {
    
    @Published var settings = [UserDefault]()
    
    override init() {
        super.init()
        guard let foundContext = context else { return }
        entity = NSEntityDescription.entity(forEntityName: EntityNames.userDefaults.rawValue,
                                            in: foundContext)!
        print("- UserDefaults()")
    }
    
    /// Create UserDefault using a tag
    func createDefault(tag: UserDefaultTag) {
        guard let context = context else { return }
        let newSetting = UserDefault(context: context)
        
        newSetting.uuid = UUID().uuidString
        newSetting.tag = tag.rawValue
        newSetting.value = DefaultValue.off.rawValue
        
        settings.append(newSetting)
        saveSelectedContext()
    }
    
    /// Create all settings if none are avalible or load into view
    func initalizeUserDefaults() {
        refreshSettings()
        if settings.count != UserDefaultTag.allCases.count {
            

            let newDefaults = findUncreatedDefaults()
            
            if newDefaults.count != 0 {
                for newDefault in newDefaults {
                    switch newDefault {
                    case .extra:
                        createDefault(tag: .extra)
                    case .notification:
                        createDefault(tag: .notification)
                    case .hideVomitGraph:
                        createDefault(tag: .hideVomitGraph)
                    case .discreteMode:
                        createDefault(tag: .discreteMode)
                    }
                }
            }
            
            
        }
        
    }
    
    
    /// Check if all users defaults are created & return array of defaults that have not been created
    func findUncreatedDefaults() -> [UserDefaultTag] {
        var tags: [String] = []
        for setting in settings {
            if let tag = setting.tag {
                tags.append(tag)
            }
        }
        
        var foundTags: [UserDefaultTag] = []
        var tagsNotFound: [UserDefaultTag] = []
        
        for userDefault in UserDefaultTag.allCases {
            for tag in tags {
                if tag == userDefault.rawValue && foundTags.contains(userDefault) == false {
                    foundTags.append(userDefault)
                }
            }
        }
        
        for tag in UserDefaultTag.allCases {
            if foundTags.contains(tag) == false {
                tagsNotFound.append(tag)
            }
        }
        
        return tagsNotFound
        
    }
    
    
    /// Fetch all UserDefaults
    func fetchAll() {
        guard let context = context else { return }
        let request: NSFetchRequest<UserDefault> = UserDefault.fetchRequest()
        do {
            settings = try context.fetch( request )
        } catch {
            print(error)
        }
    }
    
    /// Load UserSettings if none are avalible
    func refreshSettings() {
        if settings.count == 0 {
            fetchAll()
        }
    }
    
    /// Update a specific settings value
    func update(default setting: UserDefault, value: DefaultValue) {
        setting.value = value.rawValue
        saveSelectedContext()
        print("setting: \(setting.tag ?? "") value: \(value)")
    }
    
    
    /// Toggle settings value if setting has an on/off value
    func toggle(setting: UserDefault) {
        if setting.tag == UserDefaultTag.notification.rawValue ||
            setting.tag == UserDefaultTag.extra.rawValue {
            if setting.value == DefaultValue.off.rawValue {
                setting.value = DefaultValue.on.rawValue
            } else {
                setting.value = DefaultValue.off.rawValue
            }
        }
        saveSelectedContext()
    }
    
    
    
    /// Fetch value of element
    func getValue(from setting: UserDefault) -> Bool? {
        if setting.value == DefaultValue.on.rawValue {
            return true
        } else if setting.value == DefaultValue.off.rawValue {
            return false
        }
        return nil
    }
    
    
    func detectTag(for setting: UserDefault) -> UserDefaultTag? {
        for tag in UserDefaultTag.allCases {
            if setting.tag == tag.rawValue {
                return tag
            }
        }
        return nil
    }

    /// Check if display extras is on or off
    func displayExtras() -> Bool {
        refreshSettings()
        for setting in settings {
            if setting.tag == UserDefaultTag.extra.rawValue {
                guard let value = getValue(from: setting) else { return false }
                return value 
                
            }
        }
        return false
    }
    
    
    /// Check if display vomit graph is on or off
    func hideVomitGraph() -> Bool {
        refreshSettings()
        for setting in settings {
            if setting.tag == UserDefaultTag.hideVomitGraph.rawValue {
                guard let value = getValue(from: setting) else { return false }
                return value
            }
        }
        return false
    }
    
    func discreteMode() -> Bool {
        refreshSettings()
        guard let discreteModeSetting = settings.first(where: { $0.tag == UserDefaultTag.discreteMode.rawValue }) else { return false }
        guard let value = getValue(from: discreteModeSetting) else { return false }
        return value
    }
    
    
}

enum UserDefaultTag: String, CaseIterable {
    case notification = "NOTIFICATION"
    case extra = "EXTRA"
    case hideVomitGraph = "HIDE-VOMIT-GRAPH"
    case discreteMode = "DISCRETE-MODE"
    
    func rowCredentials() -> (icon: String, color: Color, title: String) {
        switch self {
        case .extra:
            return (icon: "aspectratio", color: Color.lightBlue, title: "Display Extras")
        case .notification:
            return (icon: "bell", color: Color.lightBlue, title: "Display Notifications")
        case .hideVomitGraph:
            return (icon: "rectangle.slash", color: Color.lightBlue, title: "Hide Vomit Graph")
        case .discreteMode:
            return (icon: "eye.slash", color: Color.lightBlue, title: "Discrete Mode")
        }
    }
    
}

enum DefaultValue: Int16 {
    case off = 0
    case on = 1
}

