//
//  WorkoutView.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 10.08.2022.
//

import SwiftUI

struct WorkoutView<Manager>: View where Manager: StopWatchManagerProtocol {
    var presenter: WorkoutPresenterProtocol?
    @ObservedObject var stopWatchManager: Manager
    @Environment(\.dismiss) var dismiss
    
    init() {
        stopWatchManager = StopWatchManager() as! Manager
        let manager = WorkoutManager()
        presenter = WorkoutPresenter(manager: manager)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(String(format: "%.1f", stopWatchManager.secondsElapsed))
                ActivityRingView(ringWidth: 10,
                                 percent: 90,
                                 backgroundColor: .purple.opacity(0.1),
                                 foregroundColors: [.purple, .pink])
                .frame(width: 80, height: 80)
                .previewLayout(.sizeThatFits)
                
                if stopWatchManager.state == .runnning {
                    HStack {
                        Button { self.stopWatchManager.pause() }
                    label: { Text("Pause") }
                    }
                }
                
                if stopWatchManager.state == .paused {
                    HStack {
                        Button { self.stopWatchManager.resume() }
                    label: { Text("Resume") }
                        Button { endWorkSession() }
                    label: { Text("Stop")}
                    }
                    HStack {
                        Button { endWorkSession() }
                    label: { Text("End")}
                    }
                }
            }
        }
        .onAppear {
            stopWatchManager.start()
            presenter?.authorizeHealthKit()
        }
        .onDisappear {
            presenter?.stopWorkout(date: Date())
            stopWatchManager.stop()
        }
    }
    
    private func endWorkSession() {
        stopWatchManager.stop()
        dismiss()
    }
}

//struct WorkoutView_Previews: PreviewProvider {
//    static var previews: some View {
////        WorkoutView<Any>()
//
//    }
//}
