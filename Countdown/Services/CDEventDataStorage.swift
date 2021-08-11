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
    func addEvent(title: String, targetDateTime:Date, colorName: String)
    func updateEvent(event: EventMO)
}

class CDEventDataStorage: EventDataStorage  {
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
    
    static let shared = CDEventDataStorage()
    
    private init() {
        fetchEvents()
    }
    
    private func fetchEvents(){
        let request: NSFetchRequest<EventMO> = EventMO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "targetDateTime", ascending: false)]
        let events: [EventMO]? = try? container.viewContext.fetch(request)
        guard let fetchedEvents = events else {return}
        self.events.send(fetchedEvents)
    }
    
    
    func getAllEvents() -> AnyPublisher<[EventMO], Never> {
        return events.eraseToAnyPublisher()
    }
    func addEvent(title: String, targetDateTime: Date, colorName: String) {
        let event = EventMO(context: container.viewContext)
        event.title = title
        event.targetDateTime = targetDateTime
        event.color = colorName
        saveContext()
        fetchEvents()
        
    }
    
    func updateEvent(event: EventMO) {
        self.saveContext()
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
