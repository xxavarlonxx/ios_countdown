//
//  EventReminder.swift
//  Countdown
//
//  Created by Andre Hochschulte on 22.08.21.
//

import Foundation

enum EventReminder: String,CaseIterable {
    case none
    case just
    case fiveMinutes
    case fifthTeenMinutes
    case thirtyMinutes
    case oneHour
    case oneDay
    case oneWeek
    case oneMonth
    case threeMonths
    
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
    

    public var localizedStringKey: String {
        switch self {
        case .none:
            return "reminder_none_text"
        case .just:
            return "reminder_now_text"
        case .fiveMinutes:
            return "reminder_five_minutes_text"
        case .fifthTeenMinutes:
            return "reminder_fifthteen_minutes_text"
        case .thirtyMinutes:
            return "reminder_thirty_minutes_text"
        case .oneHour:
            return "reminder_one_Hour_text"
        case .oneWeek:
            return "reminder_one_Week_text"
        case .oneMonth:
            return "reminder_one_Month_text"
        case .threeMonths:
            return "reminder_three_Months_text"
        case .oneDay:
            return "reminder_one_Day_text"
        }
    }
}


