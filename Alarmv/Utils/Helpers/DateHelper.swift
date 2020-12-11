//
//  DateHelper.swift
//  Alarmv
//
//  Created by vlsuv on 11.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import Foundation

final class DateHelper {
    
    private init() {}
    
    static func createDate(time: Date) -> Date {
        let hour = Calendar.current.component(.hour, from: time)
        let minute = Calendar.current.component(.minute, from: time)
        let weekday = Calendar.current.component(.weekday, from: time)
        
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.weekday = weekday
        components.weekdayOrdinal = 10
        components.timeZone = .current
        
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: components)!
    }
}
