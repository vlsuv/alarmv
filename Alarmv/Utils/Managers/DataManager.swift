//
//  CoreDataManager.swift
//  Alarmv
//
//  Created by vlsuv on 10.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit
import CoreData

protocol DataManagerType {
    func save()
    func delete(_ object: NSManagedObject)
    func fetch(completion: (([Alarm]) -> ()))
}

class DataManager: DataManagerType {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save() {
        do {
            try context.save()
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }
    
    func fetch(completion: ([Alarm]) -> ()) {
        do {
            let alarms = try context.fetch(Alarm.fetchRequest()) as! [Alarm]
            completion(alarms)
        } catch {
            print(error.localizedDescription)
        }
    }
}
