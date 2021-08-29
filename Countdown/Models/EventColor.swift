//
//  EventColor.swift
//  Countdown
//
//  Created by Andre Hochschulte on 09.08.21.
//

import Foundation
import SwiftUI

enum EventColor: String, CaseIterable {
    case green
    case yellow
    case blue
    case pink
    case red
    case purple
    
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
        
    public var localizedStringKey: String {
        switch self {
        case .green:
            return "color_green_text"
        case .yellow:
            return "color_yellow_text"
        case .blue:
            return "color_blue_text"
        case .pink:
            return "color_pink_text"
        case .red:
            return "color_red_text"
        case .purple:
            return "color_purple_text"
        }
    }
}
