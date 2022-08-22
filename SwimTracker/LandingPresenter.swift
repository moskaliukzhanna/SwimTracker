//
//  LandingPresenter.swift
//  SwimTracker
//
//  Created by Zhanna Moskaliuk on 11.08.2022.
//

import Foundation

protocol LandingPresenterProtocol {
    func hkAuthorization()
    func fetchRecords()
}

protocol LandingPresenterDelegate: AnyObject {
    func showErrorView(message: String)
    func showRecords(records: [Record])
    
}

final class LandingPresenter: LandingPresenterProtocol {
    private var manager: LandingManagerProtocol
    private weak var delegate: LandingPresenterDelegate?
    
    init(manager: LandingManagerProtocol, delegate: LandingPresenterDelegate?) {
        self.manager = manager
        self.delegate = delegate
    }
    
    func hkAuthorization() {
        manager.authorizeHK()
    }
    
    func fetchRecords() {
        manager.fetchRecords { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.delegate?.showErrorView(message: error.description)
            case .success(let records):
                self.delegate?.showRecords(records: records)
            }
        }
    }
}
