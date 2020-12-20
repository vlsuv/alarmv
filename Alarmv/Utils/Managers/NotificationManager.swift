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
    
    enum NotificationActionKeys {
        static let snooze: String = "snooze"
        static let stop: String = "stop"
    }
    
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
    
    func registerCategories() {
        let snoozeAction = UNNotificationAction(identifier: NotificationActionKeys.snooze,
                                                title: "snooze",
                                                options: .foreground)
        let stopAction = UNNotificationAction(identifier: NotificationActionKeys.stop,
                                              title: "stop",
                                              options: .foreground)

        let category = UNNotificationCategory(identifier: "alarm", actions: [snoozeAction, stopAction], intentIdentifiers: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    func setNotificationWithDate(id: String, title: String, date: Date, snooze: Bool, sound: Sound, completion: @escaping (Error?) -> () ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = UNNotificationSound(named: UNNotificationSoundName(sound.fileName))
        content.categoryIdentifier = "alarm"
        
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
    
    func deleteNotification(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let request = response.notification.request
        let content = request.content
        
        switch response.actionIdentifier {
        case NotificationActionKeys.snooze:
            let snoozeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
            let snoozeRequest = UNNotificationRequest(identifier: request.identifier, content: content, trigger: snoozeTrigger)
            notificationCenter.add(snoozeRequest) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        case NotificationActionKeys.stop:
            print("stop action")
        default:
            break
        }
        completionHandler()
    }
}
