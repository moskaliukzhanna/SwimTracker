//
//  WorkoutManager.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 31.08.2022.
//

import Foundation
import HealthKit

protocol WorkoutManagerProtocol: ObservableObject {
    func authorizeHealthKit() async -> Bool
    func startWorkoutSession()
    func stopWorkoutSession()
    func pauseWorkoutSession()
    func resumeWorkoutSession()
    var sessionState: HKWorkoutSessionState { get }
}

final class WorkoutManager: NSObject, ObservableObject, WorkoutManagerProtocol {
    private let hkStore: HKHealthStore
    private let hkStoreManager: HKStoreManager
    private var session: HKWorkoutSession?
    private var builder: HKWorkoutBuilder?
    @Published private(set) var sessionState: HKWorkoutSessionState = .notStarted
    
    init(hkStoreManager: HKStoreManager) {
        self.hkStoreManager = hkStoreManager
        self.hkStore = hkStoreManager.hkHealthStore
        super.init()
    }
    
    func authorizeHealthKit() async -> Bool {
        let isAuthorized = await hkStoreManager.authorizeHealthKit()
        return isAuthorized
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
    
    func endWorkout() {
        guard let session = session else {
            return
        }
        print("end")
        session.end()
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
            session?.delegate = self
            builder = session?.associatedWorkoutBuilder()
        } catch {
            print("Error - \(error)")
        }
    }
}

extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("From: \(fromState) to \(toState)")
//        if toState == .ended {
//            builder?.endCollection(withEnd: Date(), completion: { [weak self] success, error in
//                guard let self = self else { return }
//                self.builder?.finishWorkout(completion: { workout, error in
//                    self.endWorkout()
//                })
//            })
//        }
        
        sessionState = toState
    }
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        //
    }
    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
       //
    }
}
