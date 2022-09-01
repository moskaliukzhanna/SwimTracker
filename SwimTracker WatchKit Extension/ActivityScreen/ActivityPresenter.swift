//
//  ActivityPresenter.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 31.08.2022.
//

import Foundation

protocol ActivityPresenterProtocol {
    func authorizeHealthKit()
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
    
    func authorizeHealthKit() {
        print("0")
        manager.authorizeHealthKit()
    }
    
    func startWorkout() {
        //        manager.startWorkoutSession()
    }
    
    func stopWorkout(date: Date) {
        //        manager.stopWorkoutSession(date: date)
    }
    
    func pauseWorkout() {
        //        manager.pauseWorkoutSession()
    }
    
    func resumeWorkout() {
        //        manager.resumeWorkoutSession()
    }
    
}
