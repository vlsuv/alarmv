//
//  Alarm+CoreDataProperties.swift
//  Alarmv
//
//  Created by vlsuv on 10.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//
//

import Foundation
import CoreData


extension Alarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Alarm> {
        return NSFetchRequest<Alarm>(entityName: "Alarm")
    }

    @NSManaged public var enabled: Bool
    @NSManaged public var name: String
    @NSManaged public var repeatDays: NSMutableDictionary
    @NSManaged public var snoozeEnabled: Bool
    @NSManaged public var time: Date
    @NSManaged public var uuid: UUID
}
