//
//  LandingManager.swift
//  SwimTracker
//
//  Created by Zhanna Moskaliuk on 11.08.2022.
//

import Foundation

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
    func authorizeHK()
    func fetchRecords(completion: @escaping (Result<[Record], FetchResult>) -> Void)
}

final class LandingManager: LandingManagerProtocol {
    private let workoutManager = HKWorkoutManager()
    
    func authorizeHK() {
        workoutManager.authorizeHealthKit()
    }
    
    func fetchRecords(completion: @escaping (Result<[Record], FetchResult>) -> Void) {
        completion(.failure(FetchResult.noRecordsYet))
    }
}
