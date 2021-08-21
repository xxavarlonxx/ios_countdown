//
//  Event.swift
//  Countdown
//
//  Created by Andre Hochschulte on 04.08.21.
//

import Foundation
import SwiftUI


extension EventMO {
    
//    var targetDate: Date {
//        let dateComponent = Calendar.current.dateComponents([.year, .month, .day], from: targetDateTime ?? Date())
//        var newComponent = DateComponents()
//        newComponent.year = dateComponent.year!
//        newComponent.month = dateComponent.month!
//        newComponent.day = dateComponent.day!
//        return Calendar.current.date(from: newComponent)!
//    }
//    
//    var targetTime: Date {
//        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: targetDateTime ?? Date())
//        var newComponent = DateComponents()
//        newComponent.hour = dateComponent.hour!
//        newComponent.minute = dateComponent.minute!
//        return Calendar.current.date(from: newComponent)!
//    }
    
    var eventColor: EventColor {
        guard let color = color else {return EventColor.blue}
        return EventColor(rawValue: color)!
    }
    
    var delta: (Int, String) {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.year, .month,.day,.hour,.minute], from: Date(), to: targetDateTime ?? Date())
        let deltaYear = dateComponent.year!
        let deltaMonth = dateComponent.month!
        let deltaDay = dateComponent.day!
        let deltaHour = dateComponent.hour!
        let deltaMinute = dateComponent.minute!
        
        if deltaYear > 0{
            return (deltaYear, "Years")
        }
        
        if deltaMonth > 0 {
            return (deltaMonth, "Months")
        }
        
        if deltaDay > 0 {
            return (deltaDay, "Days")
        }
        
        if deltaHour > 0 {
            return (deltaHour, "Hours")
        }
        
        return (deltaMinute, "Minutes")
    }
}

extension EventMO {
    static func createDummyEvent(title: String, targetDateTime: Date, color: EventColor) -> EventMO{
        let event = EventMO()
        event.title = title
        event.targetDateTime = targetDateTime
        event.color = color.rawValue
        return event
    }
    
    static var dummyEventList: [EventMO] = {
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: today)!
        let nextYear = Calendar.current.date(byAdding: .year, value: 1, to: today)!
        
        
        return [
            EventMO.createDummyEvent(title: "Geburtstag", targetDateTime: tomorrow, color: .blue),
            EventMO.createDummyEvent(title: "Weihnachten", targetDateTime: nextWeek, color: .green),
            EventMO.createDummyEvent(title: "Urlaub", targetDateTime: nextMonth, color: .red),
            EventMO.createDummyEvent(title: "Geburtstag", targetDateTime: tomorrow, color: .pink),
            EventMO.createDummyEvent(title: "Weihnachten", targetDateTime: nextWeek, color: .purple),
            EventMO.createDummyEvent(title: "Urlaub", targetDateTime: nextYear, color: .yellow),
        ]
    }()
    
    static var dummyEvent: EventMO = {
        return dummyEventList[0]
    }()
}
