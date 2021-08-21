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
    @Published var theme: Theme = .init()
}
