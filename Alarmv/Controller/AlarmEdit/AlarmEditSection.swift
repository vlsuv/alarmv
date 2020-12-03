//
//  AlarmEditSection.swift
//  Alarmv
//
//  Created by vlsuv on 02.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import Foundation

enum AlarmEditSection: Int, CaseIterable, CustomStringConvertible {
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
}
