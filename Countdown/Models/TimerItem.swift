//
//  DateOutput.swift
//  Countdown
//
//  Created by Andre Hochschulte on 16.08.21.
//

import Foundation


struct TimerItem: Hashable {
    var value: Int
    var unity: String
    
    static func dummyTimerItem() -> TimerItem {
        return TimerItem(value: 1, unity: "Years")
    }
}
