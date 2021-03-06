//
//  CountdownApp.swift
//  Countdown
//
//  Created by Andre Hochschulte on 04.08.21.
//

import SwiftUI

@main
struct CountdownApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    
    init() {
        let storage = StorageManager.shared
//        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
//        let nextSeconds = Calendar.current.date(byAdding: .second, value: 10, to: Date() )!
        NotificationManager.shared.deleteAllPendingNotifications()
//        storage.addEvent(title: "Test", targetDateTime: nextWeek, colorName: EventColor.purple.rawValue)
//        let event = storage.addEvent(title: "TestNotification", targetDateTime: nextSeconds, colorName: EventColor.green.rawValue)
//        NotificationManager.shared.addNotificationForEvent(event)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(AppState())
                .environmentObject(Theme())
        }.onChange(of: scenePhase) { phase in
            switch phase{
            case .background:
                print("App is background")
            case .inactive:
                print("App is inactive!")
            case .active:
                print("App is active!")
            @unknown default:
                print("unknown scene phase")
            }
        }
    }
}
