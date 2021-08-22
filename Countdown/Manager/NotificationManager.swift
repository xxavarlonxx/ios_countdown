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
    func addNotificationForEvent(_ event: EventMO)
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
    
    func addNotificationForEvent(_ event: EventMO){
        let request = createNotificationRequestFromEvent(event)
        
        UNUserNotificationCenter.current().add(request) { error in
            print("UNUserNotificationCenter Add Completion")
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        print("UNUserNotificationCenter Added")
        
    }
    
    func editNotificationForEvent(_ event: EventMO){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [event.idValue.uuidString])
        let request = createNotificationRequestFromEvent(event)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteNotificationForEvent(_ event: EventMO){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [event.idValue.uuidString])
    }
    
    func deleteAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    private func createNotificationRequestFromEvent(_ event: EventMO) -> UNNotificationRequest{
        let content = UNMutableNotificationContent()
        content.badge = 1
        content.title = event.titleValue
        content.subtitle = "Event '\(event.titleValue)' starts now!"
        content.sound = UNNotificationSound.default
        
//        let dateCompoents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: event.targetDateTimeValue)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompoents, repeats: false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: event.idValue.uuidString, content: content, trigger: trigger)
        return request
    }
}


extension NotificationManager: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let eventId = response.notification.request.identifier
//        let event = StorageManager.shared.getEventById(eventId)
//        guard let fetchedEvent = event else {
//           return completionHandler()
//        }
        
        self.selectedEventId.send(eventId)
        
        completionHandler()
    }
}
