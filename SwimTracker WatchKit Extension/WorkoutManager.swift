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
    func authorizeHealthKit()
}

final class WorkoutManager: WorkoutManagerProtocol {
    private var workoutSession: HKWorkoutSession?
    private let hkHealthStore = HKHealthStore()
    
    init() {
        configureWorkoutSession()
    }
    
    private func configureWorkoutSession() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .swimming
        configuration.lapLength = HKQuantity(unit: .meter(), doubleValue: 50.0)
        configuration.swimmingLocationType = .pool
        
        do {
            try self.workoutSession = HKWorkoutSession(healthStore: hkHealthStore,
                                                       configuration: configuration)
        } catch  {
            print("Failed to created workoutSession :\(error)")
        }
    }
    
    func startWorkoutSession() {
//        fetchWorkoutData()
        workoutSession?.startActivity(with: Date())
    }
    
    func stopWorkoutSession(date: Date) {
        workoutSession?.stopActivity(with: date)
    }
    
    func authorizeHealthKit() {
        if HKHealthStore.isHealthDataAvailable() {
            let infoToRead = Set([
                HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKSampleType.quantityType(forIdentifier: .distanceSwimming)!,
                HKSampleType.workoutType()
            ])
            
            let infoToWrite = Set([
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKSampleType.quantityType(forIdentifier: .distanceSwimming)!,
                HKObjectType.workoutType()
            ])
            
            hkHealthStore.requestAuthorization(toShare: infoToWrite,
                                               read: infoToRead) { sucess, error in
                print("IS Succesful \(sucess)")
            }
        }
    }
    
    func fetchWorkoutData() {
        let calendar = Calendar.autoupdatingCurrent
                
        var dateComponents = calendar.dateComponents(
            [ .year, .month, .day ],
            from: Date()
        )

        // This line is required to make the whole thing work
        dateComponents.calendar = calendar

        let predicate = HKQuery.predicateForActivitySummary(with: dateComponents)
        let query = HKActivitySummaryQuery(predicate: predicate) { [weak self] (query, summaries, error) in
            guard let self = self else { return }

            guard let summaries = summaries, summaries.count > 0, let summary = summaries.first
            else {
                // No data returned. Perhaps check for error
                return
            }

            let energyUnit   = HKUnit.kilocalorie()
            let standUnit    = HKUnit.count()
            let exerciseUnit = HKUnit.second()
            
            let energy   = summary.activeEnergyBurned.doubleValue(for: energyUnit)
            let stand    = summary.appleStandHours.doubleValue(for: standUnit)
            let exercise = summary.appleExerciseTime.doubleValue(for: exerciseUnit)
            
            let energyGoal   = summary.activeEnergyBurnedGoal.doubleValue(for: energyUnit)
            let standGoal    = summary.appleStandHoursGoal.doubleValue(for: standUnit)
            let exerciseGoal = summary.appleExerciseTimeGoal.doubleValue(for: exerciseUnit)
            
            let energyProgress   = energyGoal == 0 ? 0 : energy / energyGoal
            let standProgress    = standGoal == 0 ? 0 : stand / standGoal
            let exerciseProgress = exerciseGoal == 0 ? 0 : exercise / exerciseGoal
            
            print("\(energyGoal)" , "\(standGoal)",  "\(exerciseGoal)")
           
        }
        hkHealthStore.execute(query)
        

    }
}

