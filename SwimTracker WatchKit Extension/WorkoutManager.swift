//
//  WorkoutManager.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 25.08.2022.
//

import Foundation
protocol WorkoutManagerProtocol {
    func authorizeHealthKit()
}

final class WorkoutManager: WorkoutManagerProtocol {
    private let hkStoreManager = HKStoreManager()
    
    func authorizeHealthKit() {
        print("1")
        hkStoreManager.authorizeHealthKit()
    }
    
    
}
