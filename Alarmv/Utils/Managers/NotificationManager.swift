//
//  AlarmManager.swift
//  Alarmv
//
//  Created by vlsuv on 06.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

final class NotificationManager: NSObject {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    enum NotificationActionKeys {
        static let snooze: String = "snooze"
        static let stop: String = "stop"
    }
    
    enum NotificationCategoryKeys {
        static let alarm: String = "alarm"
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

        let category = UNNotificationCategory(identifier: NotificationCategoryKeys.alarm, actions: [snoozeAction, stopAction], intentIdentifiers: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    func setNotificationWithDate(id: String, title: String, time: Date, repeatDays: [RepeatDay], snooze: Bool, sound: Sound, completion: @escaping (Error?) -> () ) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = UNNotificationSound(named: UNNotificationSoundName(sound.fileName))
        content.categoryIdentifier = NotificationCategoryKeys.alarm
        content.userInfo = ["id": id]
        
        let hour = Calendar.current.component(.hour, from: time)
        let minute = Calendar.current.component(.minute, from: time)
        let weekDay = Calendar.current.component(.weekday, from: time)
        
        if repeatDays.count > 0 {
            for repeatDay in repeatDays {
                var components = DateComponents()
                components.hour = hour
                components.minute = minute
                components.weekday = repeatDay.id
                components.weekdayOrdinal = 10
                components.timeZone = .current
                let calendar = Calendar(identifier: .gregorian)
                
                let triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute], from: calendar.date(from: components)!)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                notificationCenter.add(request) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    completion(nil)
                }
            }
        } else {
            var components = DateComponents()
            components.hour = hour
            components.minute = minute
            components.weekday = weekDay
            components.weekdayOrdinal = 10
            components.timeZone = .current
            let calendar = Calendar(identifier: .gregorian)
            
            let triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute], from: calendar.date(from: components)!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            notificationCenter.add(request) { error in
                if let error = error {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func reShedule(_ alarms: [Alarm]) {
        notificationCenter.removeAllPendingNotificationRequests()
        
        for alarm in alarms {
            if alarm.enabled {
                setNotificationWithDate(id: alarm.uuid, title: alarm.name, time: alarm.time, repeatDays: alarm.repeatDays, snooze: alarm.snoozeEnabled, sound: alarm.sound) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
            }
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
