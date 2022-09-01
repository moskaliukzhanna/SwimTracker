//
//  LandingPageView.swift
//  SwimTracker
//
//  Created by Zhanna Moskaliuk on 11.08.2022.
//

import Combine
import SwiftUI

struct LandingPageView: View {
    
    private let manager: LandingManagerProtocol
    private let presenter: LandingPresenterProtocol
    
    @ObservedObject var store: RecordStore
    
    init(store: RecordStore, manager: LandingManager, presenter: LandingPresenter) {
        self.store = store
        self.manager = manager
        self.presenter = presenter

    }
    
    var body: some View {
        NavigationView { () -> AnyView in
            switch store.state {
            case .loading:
                return AnyView(EmptyView())
            case .error(let error):
                return  AnyView(ErrorView(errorMessage: error))
                
                
            case .loaded( _):
                return AnyView(EmptyView())
            }
            
            
        }
        .navigationTitle("Welcome back!")
        .navigationBarTitleDisplayMode(.inline)
        
        .onAppear {
            Task {
                let isAuthorized = await presenter.hkAuthorization()
                if isAuthorized {
                    presenter.fetchRecords()
                }
            }
        }
        
    }
    
//    private func createEmptyRecordsView() -> AnyView {
//        let image = Image("swimming")
//    }
}



//struct LandingPageView_Previews: PreviewProvider {
//    static var previews: some View {
////        LandingPageView()
//    }
//}
