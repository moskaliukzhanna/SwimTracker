//
//  ActivityPresenter.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 31.08.2022.
//

import Foundation
import HealthKit

protocol ActivityPresenterProtocol {
    var workoutSessionState: HKWorkoutSessionState { get }
    func authorizeHealthKit() async -> Bool
    func startWorkout()
    func stopWorkout(date: Date)
    func pauseWorkout()
    func resumeWorkout()
}

final class ActivityPresenter: ActivityPresenterProtocol {
    private var manager: ActivityModelProtocol
    
    init(manager: ActivityModelProtocol) {
        self.manager = manager
    }
    
    var workoutSessionState: HKWorkoutSessionState {
        return manager.workoutSessionState()
    }
    
    func authorizeHealthKit() async -> Bool {
        let isAuthorized = await manager.authorizeHealthKit()
        return isAuthorized
    }
    
    func startWorkout() {
        manager.startWorkoutSession()
    }
    
    func stopWorkout(date: Date) {
        manager.stopWorkoutSession()
    }
    
    func pauseWorkout() {
        manager.pauseWorkoutSession()
    }
    
    func resumeWorkout() {
        manager.resumeWorkoutSession()
    }
    
}
