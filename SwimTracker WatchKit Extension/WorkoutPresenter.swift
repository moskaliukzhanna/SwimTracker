//
//  WorkoutPresenter.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 11.08.2022.
//

import Foundation

protocol WorkoutPresenterProtocol {
    func startWorkout()
    func stopWorkout(date: Date)
//    func updateState()
}

class WorkoutPresenter {
    private var manager: WorkoutManagerProtocol
    
    init(manager: WorkoutManagerProtocol) {
        self.manager = manager
    }
    
    
}

extension WorkoutPresenter: WorkoutPresenterProtocol {
    func startWorkout() {
        manager.startWorkoutSession()
    }
    
    func stopWorkout(date: Date) {
        manager.stopWorkoutSession(date: date)
    }
}
