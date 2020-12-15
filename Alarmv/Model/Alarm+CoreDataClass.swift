//
//  Alarm+CoreDataClass.swift
//  Alarmv
//
//  Created by vlsuv on 10.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Alarm)
public class Alarm: NSManagedObject {
    public override func awakeFromInsert() {
        self.uuid = UUID()
        self.time = Date()
        self.snoozeEnabled = false
        self.name = "Alarm"
        self.enabled = false
        self.repeatDays = [RepeatDay]()
        self.sound = Sound(name: "Early Riser", fileName: "EarlyRiser")
    }
    
    func nameOfRepeatDays() -> String {
        var nameOfRepeatDays = ""
        
        for repeatDay in repeatDays.sorted(by: { repeatDay1, repeatDay2 -> Bool in
            repeatDay1.id < repeatDay2.id
        }) {
            nameOfRepeatDays += "\(repeatDay.name) "
        }
        
        return nameOfRepeatDays
    }
}
