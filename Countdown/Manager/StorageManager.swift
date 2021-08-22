//
//  CDDataStorage.swift
//  Countdown
//
//  Created by Andre Hochschulte on 11.08.21.
//

import Foundation
import Combine
import SwiftUI
import CoreData

protocol EventDataStorage {
    func getAllEvents() -> AnyPublisher<[EventMO], Never>
    func addEvent(title: String, targetDateTime:Date, allDay: Bool, colorName: String, firstReminder: String, secondReminder: String) -> EventMO
    func deleteEvent(event: EventMO)
    func updateEvent(event: EventMO)
}

class StorageManager: EventDataStorage  {
    
    private var events = CurrentValueSubject<[EventMO],Never>([])
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Countdown")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("ERROR LOADING PERSISTENT STORE")
            }
        }
        return container
    }()
    
    static let shared = StorageManager()
    
    private init() {
        fetchEvents()
    }
    
    private func fetchEvents(){
        let request: NSFetchRequest<EventMO> = EventMO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "targetDateTime", ascending: true)]
        let events: [EventMO]? = try? container.viewContext.fetch(request)
        guard let fetchedEvents = events else {return}
        self.events.send(fetchedEvents)
    }
    
    
    func getAllEvents() -> AnyPublisher<[EventMO], Never> {
        return events.eraseToAnyPublisher()
    }
    func addEvent(title: String, targetDateTime: Date, allDay: Bool, colorName: String, firstReminder: String, secondReminder: String) -> EventMO {
        let event = EventMO(context: container.viewContext)
        event.id = UUID()
        event.title = title
        event.targetDateTime = targetDateTime
        event.allDay = allDay
        event.color = colorName
        event.firstReminder = firstReminder
        event.secondReminder = secondReminder
        event.firstReminderId = UUID()
        event.secondReminderId = UUID()
        
        saveContext()
        fetchEvents()
        return event
    }
    
    func updateEvent(event: EventMO) {
        self.saveContext()
        fetchEvents()
    }
    
    func deleteEvent(event: EventMO) {
        container.viewContext.delete(event)
        saveContext()
        fetchEvents()
    }
    
    private func saveContext(){
        do {
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
            
        } catch  {
            print(error.localizedDescription)
        }
    }
}
