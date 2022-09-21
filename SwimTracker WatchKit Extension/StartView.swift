//
//  StartView.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 10.08.2022.
//

import SwiftUI
import HealthKit

struct StartView: View {
    @State var isLinkActive = false
    
    var body: some View {
        let hkStore = HKHealthStore()
        let hkManager = HKStoreManager(healthStore: hkStore)
        let manager = WorkoutManager(hkStoreManager: hkManager)
        let presenter = ActivityPresenter(manager: manager)
        
        NavigationView {
            VStack(alignment: .center) {
                Button(action: {
                    self.isLinkActive = true
                        
                })
                
                {
                    Text("Swim")
                }
                .accessibilityIdentifier("swim_button")
            }
            .background(
                NavigationLink(destination: ActivityView<ActivityPresenter>(presenter: presenter), isActive: $isLinkActive) {
                    EmptyView()
                }
                    .hidden()
            )
        }
    }
}

//struct StartView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartView()
//    }
//}
