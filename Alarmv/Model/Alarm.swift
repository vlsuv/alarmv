//
//  Alarm.swift
//  Alarmv
//
//  Created by vlsuv on 04.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import Foundation

struct Alarm {
    var uid: String = UUID().uuidString
    var enabled: Bool = false
    var snoozeEnabled: Bool = false
    var name: String = "Alarm"
    var time: Date = Date()
    var repeatDays: [Int: String] = [Int: String]()
    
    func nameOfRepeatDays() -> String {
        var nameOfRepeatDays = ""
        
        for day in repeatDays.sorted(by: { $0.key < $1.key }) {
            nameOfRepeatDays += "\(day.value) "
        }
        
        return nameOfRepeatDays
    }
}
