//
//  HKStoreManager.swift
//  SwimTracker
//
//  Created by Zhanna Moskaliuk on 25.08.2022.
//

import Foundation
import HealthKit

protocol HKStoreProtocol {
    func authorizeHealthKit()
    func fetchDistanceSwiming()
}

final class HKStoreManager: HKStoreProtocol {
    // make sure there is only one instance of hkHealtStore
    private let hkHealthStore: HKHealthStore
//    private var session: HKWorkoutSession?
    
    init(healthStore: HKHealthStore) {
        self.hkHealthStore = healthStore
    }
    
    func authorizeHealthKit() {
        print("2")
        print("Health data available \(HKHealthStore.isHealthDataAvailable() )")
        
        if HKHealthStore.isHealthDataAvailable() {
            let typesToRead = Set([
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKObjectType.quantityType(forIdentifier: .distanceSwimming)!,
                HKObjectType.activitySummaryType()
            ])
            
            let typesToWrite = Set([
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKObjectType.quantityType(forIdentifier: .distanceSwimming)!
                
            ])
            
            self.hkHealthStore.requestAuthorization(toShare: typesToWrite,
                                                    read: typesToRead) { [weak self] sucess, error in
                guard let self = self else { return }
                let sharingStatusForCalories = self.hkHealthStore.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!)
                if sucess && sharingStatusForCalories == .sharingAuthorized {
                    self.fetchAppleWorkoutSummaries()
                    self.fetchDistanceSwiming()
                }
            }
        }
    }
    
    // fetch workout summaries from healthkit
    // active calories burned for now
    func fetchAppleWorkoutSummaries(date: Date = Date()) {
        let calendar = Calendar.autoupdatingCurrent
        var dateComponents = calendar.dateComponents(
            [ .year, .month, .day ],
            from: date
        )
        
        dateComponents.calendar = calendar
        dateComponents.day = 1
        
        let predicate = HKQuery.predicateForActivitySummary(with: dateComponents)
        let query = HKActivitySummaryQuery(predicate: predicate) { (query, summaries, error) in
            guard let summaries = summaries, summaries.count > 0, let summary = summaries.first
            else {
                if let error = error {
                    print("Error - \(error)")
                }
                return
            }
            
            let energyUnit   = HKUnit.kilocalorie()
            let energy   = summary.activeEnergyBurned.doubleValue(for: energyUnit)
            let energyGoal   = summary.activeEnergyBurnedGoal.doubleValue(for: energyUnit)
            let energyProgress   = energyGoal == 0 ? 0 : energy / energyGoal
            print("\(energyProgress)")
        }
        hkHealthStore.execute(query)
    }
    
    
    
    func fetchDistanceSwiming() {
        HKUnit.meter()
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .distanceSwimming) else {
            print("Couldn't fetch distanceSwimming quantity type")
            return
        }
        // fetching the most recent result
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: predicate,
                                  limit: Int(HKObjectQueryNoLimit),
                                  sortDescriptors: [sortDescriptor]) { (_, results, error) in
            if let error = error {
                print("Error - \(error)")
                return
            }
        }
        
        self.hkHealthStore.execute(query)
    }
    
    func startWorkoutSession() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .swimming
        configuration.swimmingLocationType = .pool
        do {
        } catch {
            
        }
    }
}


