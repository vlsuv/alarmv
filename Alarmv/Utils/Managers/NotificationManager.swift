//
//  AlarmManager.swift
//  Alarmv
//
//  Created by vlsuv on 06.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import Foundation
import UserNotifications

final class NotificationManager: NSObject {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) { didAllow, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func setNotificationWithDate(id: String, title: String, date: Date, snooze: Bool, sound: Sound, completion: @escaping (Error?) -> () ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = UNNotificationSound(named: UNNotificationSoundName(sound.fileName))
        
        let triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    func deleteNotification(_ identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
