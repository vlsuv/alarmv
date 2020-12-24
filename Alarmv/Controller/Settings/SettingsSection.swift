//
//  SettingsSection.swift
//  Alarmv
//
//  Created by vlsuv on 24.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import Foundation
import UIKit

struct SettingsSection {
    let title: String
    let options: [SettingsOptionType]
}

enum SettingsOptionType {
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
}

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let handler: (() -> ())
}

struct SettingsSwitchOption {
    let title: String
    let icon: UIImage?
    let handler: (() -> ())
    var isOn: Bool
}
