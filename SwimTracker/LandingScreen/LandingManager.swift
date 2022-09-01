//
//  LandingManager.swift
//  SwimTracker
//
//  Created by Zhanna Moskaliuk on 11.08.2022.
//

import Foundation
import HealthKit

enum FetchResult: String, Error {
    case noRecordsYet
    
    var description: String {
        switch self {
        case .noRecordsYet:
            return "You have no records yet.\nStart your workout to add some"
        }
    }
}

protocol LandingManagerProtocol {
    func authorizeHK() async -> Bool
    func fetchRecords(completion: @escaping (Result<[Record], FetchResult>) -> Void)
}

final class LandingManager: LandingManagerProtocol {
    private let hkStore = HKHealthStore()
    private let workoutManager: HKStoreManager
    
    init() {
        self.workoutManager = HKStoreManager(healthStore: hkStore)
    }
    
    func authorizeHK() async -> Bool {
        let isAuthorized = await workoutManager.authorizeHealthKit()
        return isAuthorized
    }
    
    func fetchRecords(completion: @escaping (Result<[Record], FetchResult>) -> Void) {
        completion(.failure(FetchResult.noRecordsYet))
    }
}
