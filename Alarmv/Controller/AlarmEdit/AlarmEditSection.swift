//
//  AlarmEditSection.swift
//  Alarmv
//
//  Created by vlsuv on 02.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import Foundation

protocol AlarmEditSectionType: CustomStringConvertible {
    var containsDetailSettingTextLabel: Bool { get }
    var containsDetailSettingTextField: Bool { get }
}

enum AlarmEditSection: Int, CaseIterable, AlarmEditSectionType {
    case alarmTime
    case alarmDate
    case repeatDate
    case alarmLabel
    case alarmSound
    case alarmSnooze
    
    var description: String {
        switch self {
        case .alarmTime:
            return "Alarm Time"
        case .alarmDate:
            return "Alarm Date"
        case .repeatDate:
            return "Repeat"
        case .alarmLabel:
            return "Label"
        case .alarmSound:
            return "Sound"
        case .alarmSnooze:
            return "Snooze"
        }
    }
    
    var containsDetailSettingTextLabel: Bool {
        switch self {
        case .alarmTime:
            return false
        case .alarmDate:
            return false
        case .repeatDate:
            return true
        case .alarmLabel:
            return false
        case .alarmSound:
            return true
        case .alarmSnooze:
            return false
        }
    }
    
    var containsDetailSettingTextField: Bool {
        switch self {
        case .alarmTime:
            return false
        case .alarmDate:
            return false
        case .repeatDate:
            return false
        case .alarmLabel:
            return true
        case .alarmSound:
            return false
        case .alarmSnooze:
            return false
        }
    }
}
