//
//  WorkoutManager.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 31.08.2022.
//

import Foundation
import HealthKit

protocol WorkoutManagerProtocol {
    func authorizeHealthKit() async -> Bool
    func startWorkoutSession()
    func stopWorkoutSession()
    func pauseWorkoutSession()
    func resumeWorkoutSession()
    func workoutSessionState() -> HKWorkoutSessionState
}

final class WorkoutManager: WorkoutManagerProtocol {
    private let hkStore = HKHealthStore()
    private let hkStoreManager: HKStoreManager
    private var session: HKWorkoutSession?
    private var builder: HKWorkoutBuilder?
    
    init() {
        self.hkStoreManager = HKStoreManager(healthStore: hkStore)
    }
    
    func authorizeHealthKit() async -> Bool {
        let isAuthorized = await hkStoreManager.authorizeHealthKit()
        return isAuthorized
    }
    
    func workoutSessionState() -> HKWorkoutSessionState {
        guard let session = session else {
            return .notStarted
        }
        return session.state
    }
    
    func startWorkoutSession() {
        createWorkoutSession()
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
    
    private func createWorkoutSession() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .swimming
        configuration.lapLength = HKQuantity(unit: .meter(), doubleValue: 50)
        configuration.swimmingLocationType = .pool
        do {
            session = try HKWorkoutSession(healthStore: hkStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            print("Error - \(error)")
        }
    }
}
