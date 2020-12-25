//
//  UserSettings.swift
//  Alarmv
//
//  Created by vlsuv on 25.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import Foundation

final class UserSettings {
    
    private enum SettingKeys: String {
        case darkMode
    }
    
    static var darkMode: Bool {
        get {
            return UserDefaults.standard.bool(forKey: SettingKeys.darkMode.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingKeys.darkMode.rawValue
            defaults.set(newValue, forKey: key)
        }
    }
}
