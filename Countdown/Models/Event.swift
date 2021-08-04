//
//  Event.swift
//  Countdown
//
//  Created by Andre Hochschulte on 04.08.21.
//

import Foundation
import SwiftUI

enum EventColor {
    case GREEN
    case YELLOW
    case BLUE
    case PINK
    case RED
    case PURPLE
    
    public var value: Color {
        switch self {
        case .GREEN:
            return Color.green
        case .BLUE:
            return Color.blue
        case .PINK:
            return Color.pink
        case .RED:
            return Color.red
        case .YELLOW:
            return Color.yellow
        case .PURPLE:
            return Color.purple
        }
    }
    
    public var contrastValue: Color {
        switch self {
        case .GREEN:
            return Color.red
        case .BLUE:
            return Color.orange
        case .PINK:
            return Color.green
        case .RED:
            return Color.green
        case .YELLOW:
            return Color.purple
        case .PURPLE:
            return Color.yellow
        }
    }
    
    public var textColor: Color {
        switch self {
        case .GREEN:
            return Color.white
        default:
            return Color(UIColor.darkGray)
        }
    }
}

struct Event: Identifiable {
    var id = UUID()
    var title: String
    var targetDateTime: Date
    var color: EventColor
    

    static var dummyEventList: [Event] = {
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: today)!
        return [
            Event(title: "Geburtstag", targetDateTime: tomorrow, color: .BLUE),
            Event(title: "Weihnachten", targetDateTime: nextWeek, color: .GREEN),
            Event(title: "Urluab", targetDateTime: nextMonth, color: .RED)
        ]
    }()
    
    var deltaDays: Int {
        let calendar = Calendar.current
        return calendar.numberOfDaysBetween(Date(), and: targetDateTime)
    }
    
    static var dummyEvent: Event = {
        return dummyEventList[0]
    }()
}


extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}
