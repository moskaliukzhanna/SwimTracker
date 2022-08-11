//
//  WorkoutView.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 10.08.2022.
//

import SwiftUI

struct WorkoutView: View {
    var presenter: WorkoutPresenterProtocol?
    
    init() {
        let manager = WorkoutManager()
        presenter = WorkoutPresenter(manager: manager)
        presenter?.startWorkout()
    }
    
    var body: some View {
        VStack {
            Text("0:00")
            Spacer().frame(width: 20, height: 20, alignment: .center)
            ActivityRingView(ringWidth: 10,
                             percent: 90,
                             backgroundColor: .purple.opacity(0.1),
                             foregroundColors: [.purple, .pink])
            .frame(width: 100, height: 100)
            .previewLayout(.sizeThatFits)
            
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
        
    }
}
