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
            let allDataTypes = Set([
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
            ])
            
            self.hkHealthStore.requestAuthorization(toShare: allDataTypes,
                                                    read: allDataTypes) { [weak self] sucess, error in
                guard let self = self else { return }
                print("IS Succesful \(sucess)")
                if sucess {
                    //
                    print(self.hkHealthStore.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!).rawValue)
                    
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.fetchWorkoutData()
//                    }
                    
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
        dateComponents.day = 1
        let startDate = calendar.date(byAdding: .hour, value: -12, to: Date())
        let endDate = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
//        let query = HKActivitySummaryQuery(predicate: predicate) { (query, summaries, error) in
        let query = HKStatisticsQuery(quantityType: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!, quantitySamplePredicate: predicate) { query, summary, error in
            if let error = error {
                print("Error - \(error)")
            }
            if let sample = summary {
                let energy = sample.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0.0
                
            }
        }
            print("2")
            
//            guard let summaries = summaries, summaries.count > 0, let summary = summaries.first
//            else {
//                // No data returned. Perhaps check for error
//                print("3")
//                if let error = error {
//                    print("Error - \(error)")
//                }
//                return
//            }
//
//            let energyUnit   = HKUnit.kilocalorie()
//            //            let standUnit    = HKUnit.count()
//            //            let exerciseUnit = HKUnit.second()
//
//            let energy   = summary.activeEnergyBurned.doubleValue(for: energyUnit)
//            //            let stand    = summary.appleStandHours.doubleValue(for: standUnit)
//            //            let exercise = summary.appleExerciseTime.doubleValue(for: exerciseUnit)
//            //
//            let energyGoal   = summary.activeEnergyBurnedGoal.doubleValue(for: energyUnit)
//            //            let standGoal    = summary.appleStandHoursGoal.doubleValue(for: standUnit)
//            //            let exerciseGoal = summary.appleExerciseTimeGoal.doubleValue(for: exerciseUnit)
//
//            let energyProgress   = energyGoal == 0 ? 0 : energy / energyGoal
//            //            let standProgress    = standGoal == 0 ? 0 : stand / standGoal
//            //            let exerciseProgress = exerciseGoal == 0 ? 0 : exercise / exerciseGoal
//            print("4")
//            print("\(energyGoal)")
//
//        }
        hkHealthStore.execute(query)
//        print("1")
        
        
    }
}



