//
//  AlarmController.swift
//  Alarm
//
//  Created by Brooke Kumpunen on 3/11/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        //1) Create the content!
        let content = UNMutableNotificationContent()
        content.title = "Alarm is active"
        content.body = "Your alarm is mad at you!"
        //Put a sound here, if you like. But after you figure out the rest of this dang process XD
        //2) Specify the delivery conditions. Where, when, how.
        //I need to create an instance of: UNCalendarNotificationTrigger. But before I can make this, I need to create a DateComponents using the fireDate.
        let date = alarm.fireDate //I need to somehow turn this date into dateComponents. Hmmmm...
        let dateComponents = Calendar.current.dateComponents([.hour,.minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to add notification request. \(error): \(error.localizedDescription)")
                }
            }
        }
    
    func cancelUserNotifications(for alarm: Alarm) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
        }
    }

class AlarmController: Codable, AlarmScheduler {
    
    //Singleton
    static let shared = AlarmController()
    
    //Source of truth
    var alarms: [Alarm] = []
    
//    var mockAlarms: [Alarm] {
//        let alarm1 = Alarm(name: "Alarm1", enabled: true, fireDate: Date())
//        let alarm2 = Alarm(name: "Alarm2", enabled: false, fireDate: Date())
//        return [alarm1, alarm2]
//    }
//
//    Remove when you launch the app.
//    init() {
//        self.alarms = self.mockAlarms
//    }
    
    
    //CRUD:
    //Create
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let alarm = Alarm(name: name, enabled: enabled, fireDate: fireDate)
        alarms.append(alarm)
        saveToPersistentStore()
        scheduleUserNotifications(for: alarm)
    }
    
    //Update
    func updateAlarm(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.enabled = enabled
        saveToPersistentStore()
        cancelUserNotifications(for: alarm)
        scheduleUserNotifications(for: alarm)
    }
    
    //Delete
    func deleteAlarm(alarm: Alarm) {
        guard let index = alarms.index(of: alarm) else {return}
        alarms.remove(at: index)
        saveToPersistentStore()
        cancelUserNotifications(for: alarm)
    }
    
    //MARK: Methods
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        if alarm.enabled {
            //Schedule a notification
            scheduleUserNotifications(for: alarm)
            
        } else {
            //Cancel a notification
            cancelUserNotifications(for: alarm)
        }
    }
    
    //MARK: Persistence
    
    func fileURL() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = path[0]
        let fileName = "alarm.json"
        let fullURL = documentDirectory.appendingPathComponent(fileName)
        return fullURL
    }
    
    func saveToPersistentStore() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(alarms)
            try data.write(to: fileURL())
        } catch {
            print("There was an error saving data. \(error): \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let alarms = try decoder.decode([Alarm].self, from: data)
            self.alarms = alarms
        } catch {
            print("There was a problem loading data. \(error): \(error.localizedDescription)")
        }
    }
    
}
