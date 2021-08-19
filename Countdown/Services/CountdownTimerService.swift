//
//  CountdownTimerService.swift
//  Countdown
//
//  Created by Andre Hochschulte on 19.08.21.
//

import Foundation
import Combine

protocol TimerService {
    func updateDeltaTimeFrom(_ from: Date, to: Date)
    func getTimerItems() -> AnyPublisher<[TimerItem], Never>
}


class CountdownTimerService: TimerService {
    private var timerItems: CurrentValueSubject<[TimerItem], Never>
    
    init() {
        timerItems = CurrentValueSubject([])
    }
    
    func updateDeltaTimeFrom(_ from: Date, to: Date) {
        let calendar = Calendar.current
        let deltaComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: from, to: to )
        
        let totalYears = calendar.dateComponents([.year], from: from, to: to ).year!
        let totalMonths = calendar.dateComponents([.month], from: from, to: to ).month!
        let totalDays = calendar.dateComponents([.day], from: from, to: to ).day!
        let totalHours = calendar.dateComponents([.hour], from: from, to: to ).hour!
        let totalMinutes = calendar.dateComponents([.minute], from: from, to: to ).minute!
        let totalSeconds = calendar.dateComponents([.second], from: from, to: to ).second!
        
        let relativeYear = deltaComponents.year!
        let relativeMonth =  deltaComponents.month!
        let relativeDay = deltaComponents.day!
        let relativeHour = deltaComponents.hour!
        let relativeMinute = deltaComponents.minute!
        let relativeSecond = deltaComponents.second!
        
        var newTimerItems  = [TimerItem]()
        if totalYears > 0 {
            newTimerItems.append(TimerItem(value: relativeYear, unity: "Years"))
        }
        
        if totalMonths > 0 {
            newTimerItems.append(TimerItem(value: relativeMonth, unity: "Months"))
        }
        
        if totalDays > 0 {
            newTimerItems.append(TimerItem(value: relativeDay, unity: "Days"))
        }
        
        if totalHours > 0 {
            newTimerItems.append(TimerItem(value: relativeHour, unity: "Hours"))
        }
        
        if totalMinutes > 0 {
            newTimerItems.append(TimerItem(value: relativeMinute, unity: "Minutes"))
        }
        
        if totalSeconds > 0 {
            newTimerItems.append(TimerItem(value: relativeSecond, unity: "Seconds"))
        }
        
        self.timerItems.send(newTimerItems)
    }
    
    func getTimerItems() -> AnyPublisher<[TimerItem], Never>{
        return self.timerItems.eraseToAnyPublisher()
    }
    
}
