//
//  WorkoutManager.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 31.08.2022.
//

import Foundation
import HealthKit

protocol WorkoutManagerProtocol {
    func authorizeHealthKit()
    func startWorkoutSession()
    func stopWorkoutSession()
    func pauseWorkoutSession()
    func resumeWorkoutSession()
    func workoutSessionStatus() -> HKWorkoutSessionState
}

final class WorkoutManager: WorkoutManagerProtocol {
    private let hkStore = HKHealthStore()
    private let hkStoreManager: HKStoreManager
    private var session: HKWorkoutSession?
    private var builder: HKWorkoutBuilder?
    
    init() {
        self.hkStoreManager = HKStoreManager(healthStore: hkStore)
    }
    
    func authorizeHealthKit() {
        hkStoreManager.authorizeHealthKit()
    }
    
    func workoutSessionStatus() -> HKWorkoutSessionState {
        guard let session = session else {
            return .notStarted
        }
        return session.state
    }
    
    func startWorkoutSession() {
        guard let session = session else {
            return
        }
        session.startActivity(with: Date())
    }
    
    func stopWorkoutSession() {
        guard let session = session else {
            return
        }
        session.stopActivity(with: Date())
    }
    
    func pauseWorkoutSession() {
        guard let session = session else {
            return
        }
        session.pause()
    }
    
    func resumeWorkoutSession() {
        guard let session = session else {
            return
        }
        session.resume()
    }
}
