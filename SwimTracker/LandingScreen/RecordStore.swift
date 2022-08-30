//
//  RecordStore.swift
//  SwimTracker
//
//  Created by Zhanna Moskaliuk on 11.08.2022.
//

import Foundation

final class RecordStore: ObservableObject {
    enum State {
        case loading
        case error(message: String)
        case loaded(records: [Record])
    }
    
    @Published var state: State = .loading
}

extension RecordStore: LandingPresenterDelegate {
    func showErrorView(message: String) {
        self.state = .error(message: message)
    }
    
    func showRecords(records: [Record]) {
        self.state = .loaded(records: records)
    }
    
    
}
