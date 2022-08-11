//
//  LandingManager.swift
//  SwimTracker
//
//  Created by Zhanna Moskaliuk on 11.08.2022.
//

import Foundation

enum FetchError: Error {
    case noRecords
}

protocol LandingManagerProtocol {
    func fetchRecords(completion: @escaping (Result<[Record], Error>) -> Void)
}

final class LandingManager: LandingManagerProtocol {
    func fetchRecords(completion: @escaping (Result<[Record], Error>) -> Void) {
        completion(.failure(FetchError.noRecords))
    }
}
