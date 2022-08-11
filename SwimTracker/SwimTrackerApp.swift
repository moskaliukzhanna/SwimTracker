//
//  SwimTrackerApp.swift
//  SwimTracker
//
//  Created by Zhanna Moskaliuk on 10.08.2022.
//

import SwiftUI

@main
struct SwimTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            let manager = LandingManager()
            let store = RecordStore()
            let presenter = LandingPresenter(manager: manager, delegate: store)
            LandingPageView(store: store, manager: manager, presenter: presenter)
        }
    }
}
