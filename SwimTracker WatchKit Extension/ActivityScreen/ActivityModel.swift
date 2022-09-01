//
//  ActivityModel.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 31.08.2022.
//

import Foundation
import HealthKit

protocol ActivityModelProtocol {
    func authorizeHealthKit()
    func startWorkoutSession()
    func stopWorkoutSession()
    func pauseWorkoutSession()
    func resumeWorkoutSession()
    func workoutSessionStatus() -> HKWorkoutSessionState
}

final class ActivityModel: ActivityModelProtocol {
    private let manager: WorkoutManagerProtocol
    
    init() {
        self.manager = WorkoutManager()
    }
    
    func authorizeHealthKit() {
        manager.authorizeHealthKit()
    }
    
    func workoutSessionStatus() -> HKWorkoutSessionState {
       return manager.workoutSessionStatus()
    }
    
    func startWorkoutSession() {
        manager.startWorkoutSession()
    }
    
    func stopWorkoutSession() {
        manager.stopWorkoutSession()
    }
    
    func pauseWorkoutSession() {
        manager.pauseWorkoutSession()
    }
    
    func resumeWorkoutSession() {
        manager.resumeWorkoutSession()
    }
}
