//
//  WorkoutManager.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 11.08.2022.
//

import Foundation
import HealthKit

protocol WorkoutManagerProtocol {
    func startWorkoutSession()
    func stopWorkoutSession(date: Date)
}

class WorkoutManager: WorkoutManagerProtocol {
    private var workoutSession: HKWorkoutSession?
    
    init() {
        configureWorkoutSession()
    }
    
    private func configureWorkoutSession() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .swimming
        configuration.lapLength = HKQuantity(unit: .meter(), doubleValue: 50.0)
        configuration.swimmingLocationType = .pool
        
        do {
            try self.workoutSession = HKWorkoutSession(healthStore: HKHealthStore(),
                                                       configuration: configuration)
        } catch  {
            print("Failed to created workoutSession :\(error)")
        }
    }
    
    func startWorkoutSession() {
        workoutSession?.startActivity(with: Date())
    }
    
    func stopWorkoutSession(date: Date) {
        workoutSession?.stopActivity(with: date)
    }
}

