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
    
    var body: some Scene {
        WindowGroup {
            MainView()
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
