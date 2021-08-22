//
//  EventReminder.swift
//  Countdown
//
//  Created by Andre Hochschulte on 22.08.21.
//

import Foundation

enum EventReminder: String,CaseIterable {
    case none = "None"
    case just = "At time of event"
    case fiveMinutes = "5 Minutes before"
    case fifthTeenMinutes = "15 Minutes before"
    case thirtyMinutes = "30 Minutes before"
    case oneHour = "1 Hour before"
    case oneDay = "1 Day before"
    case oneWeek = "1 Week before"
    case oneMonth = "1 Month before"
    case threeMonths = "3 Months before"
    
    public var description: String {
        switch self {
        case .none:
            return "None"
        case .just:
            return "starts now"
        case .fiveMinutes:
            return "starts in 5 Minutes"
        case .fifthTeenMinutes:
            return "starts in 15 Minutes"
        case .thirtyMinutes:
            return "starts in 30 Minutes"
        case .oneHour:
            return "starts in 1 Hour"
        case .oneWeek:
            return "starts in 1 Week"
        case .oneMonth:
            return "starts in 1 Month"
        case .threeMonths:
            return "starts in 3 Months"
        case .oneDay:
            return "starts in 1 Day"
        }
    }
    
    func notificationDateForDate(_ targetDate: Date) -> Date {
        let calendar = Calendar.current
        switch self {
        case .just:
            return targetDate
        case .fiveMinutes:
            return calendar.date(byAdding: .minute, value: -5, to: targetDate)!
        case .fifthTeenMinutes:
            return calendar.date(byAdding: .minute, value: -15, to: targetDate)!
        case .thirtyMinutes:
            return calendar.date(byAdding: .minute, value: -30, to: targetDate)!
        case .oneHour:
            return calendar.date(byAdding: .hour, value: -1, to: targetDate)!
        case .oneDay:
            return calendar.date(byAdding: .day, value: -1, to: targetDate)!
        case .oneWeek:
            return calendar.date(byAdding: .day, value: -7, to: targetDate)!
        case .oneMonth:
            return calendar.date(byAdding: .month, value: -1, to: targetDate)!
        case .threeMonths:
            return calendar.date(byAdding: .month, value: -3, to: targetDate)!
        case .none:
            return targetDate
        }
    }
    
//    static func getEventReminderByName(_ name: String) -> EventReminder{
//        return EventReminder(rawValue: name)!
//    }
    
    static func allCasesAsString() -> [String]  {
        var list = [String]()
        for reminderCase in allCases {
            let value = reminderCase.rawValue
            list.append(value)
        }
        return list
    }
}


