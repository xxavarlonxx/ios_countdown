//
//  Extensions.swift
//  Countdown
//
//  Created by Andre Hochschulte on 09.08.21.
//

import Foundation

extension Calendar {
    
    func combine(date: Date, with time: Date) -> Date {
        let dateComponent = self.dateComponents([.year, .month, .day], from: date)
        let timeComponent = self.dateComponents([.hour, .minute, .second], from: time)
        
        var newComponent = DateComponents()
        newComponent.year = dateComponent.year!
        newComponent.month = dateComponent.month!
        newComponent.day = dateComponent.day!
        newComponent.hour = timeComponent.hour!
        newComponent.minute = timeComponent.minute!
        newComponent.second = timeComponent.second!
        
        return Calendar.current.date(from: newComponent)!
    }
}
