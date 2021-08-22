//
//  AppState.swift
//  Countdown
//
//  Created by Andre Hochschulte on 21.08.21.
//

import Foundation
import Combine


class AppState: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var finishedEvent: EventMO?
    
    var hasUserNotificationPermission: Bool {
        get{
            UserDefaults.standard.bool(forKey: "notificationPermission")
        }
        set{
            UserDefaults.standard.setValue(true, forKey: "notificationPermission")
        }
    }
    
    var hasAlreadyAskForNotificationPermission: Bool {
        get{
            UserDefaults.standard.bool(forKey: "notificationAskForPermission")
        }
        set{
            UserDefaults.standard.setValue(true, forKey: "notificationAskForPermission")
        }
    }

}
