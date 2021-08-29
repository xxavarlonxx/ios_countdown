//
//  EventReminder.swift
//  Countdown
//
//  Created by Andre Hochschulte on 22.08.21.
//

import Foundation

enum EventReminder: String,CaseIterable {
    case none = "reminder_none_text"
    case just = "reminder_now_text"
    case fiveMinutes = "reminder_five_minutes_text"
    case fifthTeenMinutes = "reminder_fifthteen_minutes_text"
    case thirtyMinutes = "reminder_thirty_minutes_text"
    case oneHour = "reminder_one_Hour_text"
    case oneDay = "reminder_one_Day_text"
    case oneWeek = "reminder_one_Week_text"
    case oneMonth = "reminder_one_Month_text"
    case threeMonths = "reminder_three_Months_text"
    
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
    
    static func allCasesAsLocalizationStringKey() -> [String]  {
        var list = [String]()
        for reminderCase in allCases {
            let value = reminderCase.rawValue
            list.append(value)
        }
        return list
    }
}


