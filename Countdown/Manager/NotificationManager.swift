//
//  CountdownNotificationService.swift
//  Countdown
//
//  Created by Andre Hochschulte on 21.08.21.
//

import Foundation
import UserNotifications
import Combine

protocol NotificationService {
    func addNotificationsForEvent(_ event: EventMO)
    func editNotificationForEvent(_ event: EventMO)
    func deleteNotificationForEvent(_ event: EventMO)
    func subcribeToSelectedEvent() -> AnyPublisher<String, Never>
}


class NotificationManager: NSObject, NotificationService {
    
    static var shared = NotificationManager()
    
    private var selectedEventId = PassthroughSubject<String, Never>()
    
    private override init(){
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func subcribeToSelectedEvent() -> AnyPublisher<String, Never> {
        return selectedEventId.eraseToAnyPublisher()
    }
    
    func addNotificationsForEvent(_ event: EventMO){
        let requests = createNotificationRequestsFromEvent(event)
        
        for request in requests {
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func editNotificationForEvent(_ event: EventMO){
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [event.firstReminderIdValue.uuidString, event.secondReminderIdValue.uuidString])
        let requests = createNotificationRequestsFromEvent(event)
        for request in requests {
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteNotificationForEvent(_ event: EventMO){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [event.firstReminderIdValue.uuidString, event.secondReminderIdValue.uuidString])
    }
    
    func deleteAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    private func createNotificationRequestsFromEvent(_ event: EventMO) -> [UNNotificationRequest]{
        var requests = [UNNotificationRequest]()
        
        if event.firstReminderValue != EventReminder.none.rawValue {
            let reminder = EventReminder(rawValue: event.firstReminderValue)!
            
            let content = UNMutableNotificationContent()
            content.badge = 1
            content.title = event.titleValue
            content.subtitle = "Event '\(event.titleValue)' \(reminder.description)!"
            content.sound = UNNotificationSound.default
            
            let triggerDate = reminder.notificationDateForDate(event.targetDateTimeValue)
            
            let dateCompoents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompoents, repeats: false)
            
            let request = UNNotificationRequest(identifier: event.firstReminderIdValue.uuidString, content: content, trigger: trigger)
            print("New notification Request for first reminder with id \(event.firstReminderIdValue) at \(triggerDate)")
            requests.append(request)
        }
        
        
        if event.secondReminderValue != EventReminder.none.rawValue {
            let reminder = EventReminder(rawValue: event.firstReminderValue)!
            
            let content = UNMutableNotificationContent()
            content.badge = 1
            content.title = event.titleValue
            content.subtitle = "Event '\(event.titleValue)' \(reminder.description)!"
            content.sound = UNNotificationSound.default
            
            let triggerDate = reminder.notificationDateForDate(event.targetDateTimeValue)
            
            let dateCompoents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompoents, repeats: false)
            
            let request = UNNotificationRequest(identifier: event.secondReminderIdValue.uuidString, content: content, trigger: trigger)
            print("New notification Request for second reminder with id \(event.secondReminderIdValue) at \(triggerDate)")
            requests.append(request)
        }
        
        
        return requests
    }
}


extension NotificationManager: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let eventId = response.notification.request.identifier
        self.selectedEventId.send(eventId)
        completionHandler()
    }
}
