//
//  UserDefaults.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/27/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import CoreData

class UserDefaults: CoreDataHandler {
    
    @Published var settings = [UserDefault]()
    
    override init() {
        super.init()
        guard let foundContext = context else { return }
        entity = NSEntityDescription.entity(forEntityName: EntityNames.userDefaults.rawValue,
                                            in: foundContext)!
        print("UserDefaults()")
    }
    
    /// Create all settings if none are avalible or load into view
    func initalizeUserDefaults() {
        refreshSettings()
        if settings.count == 0 {
            createDefault(tag: .extra)
            createDefault(tag: .notification)
        }
    }
    
    /// Create UserDefault using a tag
    func createDefault(tag: UserDefaultTag) {
        guard let context = context else { return }
        let newSetting = UserDefault(context: context)
        
        newSetting.uuid = UUID().uuidString
        newSetting.tag = tag.rawValue
        newSetting.value = DefaultValue.off.rawValue
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
    
}

enum UserDefaultTag: String {
    case notification = "NOTIFICATION"
    case extra = "EXTRA"
}

enum DefaultValue: Int16 {
    case off = 0
    case on = 1
}
