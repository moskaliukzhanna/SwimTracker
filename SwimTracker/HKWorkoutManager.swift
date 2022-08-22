//
//  HKWorkoutManager.swift
//  SwimTracker
//
//  Created by Zhanna Moskaliuk on 22.08.2022.
//

import Foundation
import HealthKit

final class HKWorkoutManager {
    
    private let hkHealthStore = HKHealthStore()
    
    func authorizeHealthKit() {
        print("Health data available \(HKHealthStore.isHealthDataAvailable() )")
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
            
          
                self.hkHealthStore.requestAuthorization(toShare: infoToWrite,
                                                   read: infoToRead) { [weak self] sucess, error in
                    guard let self = self else { return }
                    print("IS Succesful \(sucess)")
                    if sucess {
                        self.fetchWorkoutData()
                    }
                
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
        let query = HKActivitySummaryQuery(predicate: predicate) { (query, summaries, error) in
            print("2")
            
            guard let summaries = summaries, summaries.count > 0, let summary = summaries.first
            else {
                // No data returned. Perhaps check for error
                print("3")
                if let error = error {
                    print("Error - \(error)")
                }
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
            print("4")
            print("\(energyGoal)" , "\(standGoal)",  "\(exerciseGoal)")
           
        }
        hkHealthStore.execute(query)
        print("1")
        

    }
}



