//
//  ActivityPresenter.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 31.08.2022.
//

import Foundation
import HealthKit
import SwiftUI

protocol ActivityPresenterProtocol {
    var sessionInProgress: Bool { get }
    func authorizeHealthKit() async -> Bool
    func startWorkout()
    func endWorkout()
    func stopWorkout(date: Date)
    func pauseWorkout()
    func resumeWorkout()
}

final class ActivityPresenter: ActivityPresenterProtocol {
    @ObservedObject var manager: WorkoutManager
    @State var isWorkingout = false
    
    init(manager: WorkoutManager) {
        self.manager = manager
        self.isWorkingout = manager.sessionState == .running
    }
    
    var sessionInProgress: Bool {
        return manager.sessionState == .running
    }
    
    func authorizeHealthKit() async -> Bool {
        let isAuthorized = await manager.authorizeHealthKit()
        return isAuthorized
    }
    
    func startWorkout() {
        manager.startWorkoutSession()
    }
    
    func endWorkout() {
        manager.endWorkout()
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
