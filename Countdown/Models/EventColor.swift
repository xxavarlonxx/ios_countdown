//
//  EventColor.swift
//  Countdown
//
//  Created by Andre Hochschulte on 09.08.21.
//

import Foundation
import SwiftUI

enum EventColor: String, CaseIterable {
    case green = "color_green_text"
    case yellow = "color_yellow_text"
    case blue = "color_blue_text"
    case pink = "color_pink_text"
    case red = "color_red_text"
    case purple = "color_purple_text"
    
    public var color: Color {
        switch self {
        case .green:
            return Color.green
        case .blue:
            return Color.blue
        case .pink:
            return Color.pink
        case .red:
            return Color.red
        case .yellow:
            return Color.yellow
        case .purple:
            return Color.purple
        }
    }
    
    static func rawValueList() -> [String]  {
        var list = [String]()
        for colorCase in allCases {
            let value = colorCase.rawValue
            list.append(value)
        }
        return list
    }
}
