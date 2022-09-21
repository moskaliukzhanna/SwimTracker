//
//  ActivityView.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 31.08.2022.
//

import Foundation
import SwiftUI
import HealthKit

struct ActivityView<Presenter>: View where Presenter: ActivityPresenterProtocol {
    let presenter: Presenter
    @ObservedObject var stopWatchManager: StopWatchManager
    @Environment(\.dismiss) var dismiss
    @State private var isWorkoutView = true
    
    init(presenter: ActivityPresenterProtocol) {
        self.stopWatchManager = StopWatchManager()
        self.presenter = presenter as! Presenter
    }
    
    var body: some View {
        NavigationView {
            VStack {
                topView
                    .onTapGesture {
                        isWorkoutView.toggle()
                    }
                Spacer()
                    .frame(width: 120, height: 20, alignment: .center)
                bottomView
                    .frame(width: 120, height: 30)
            }
        }
        .onAppear {
            Task {
                let isAuthorized = await presenter.authorizeHealthKit()
                if isAuthorized {
                    startWorkout()
                }
            }
        }
        .onChange(of: presenter.sessionInProgress, perform: { change in
            print("Change")
        })
        
        .onDisappear {
            endWorkout()
        }
    }
    
    private var topView: some View {
        VStack {
            Text(String(format: "%.1f", stopWatchManager.secondsElapsed))
            if isWorkoutView {
                PulseRingView(foregroundColors: [.blue.opacity(0.8), .blue.opacity(0.5)],
                              seconds: stopWatchManager.secondsElapsed)
            } else {
                ActivityRingView(ringWidth: 10,
                                 percent: 5,
                                 backgroundColor: .purple.opacity(0.1),
                                 foregroundColors: [.purple, .pink])
            }
        }
    }
    
    private var bottomView: some View {
        VStack {
            HStack {
                switch stopWatchManager.state {
                case .runnning:
                    Button(action: {
                        pauseWorkout()
                        
                    }) {
                        Image("pause")
                            .resizable()
                            .scaledToFit()
                    }
                    
                case .paused:
                    Button(action: {
                        resumeWorkout()
                    }) {
                        
                        Image("swimming")
                            .resizable()
                            .scaledToFit()
                    }
                    Button(action: {
                        dismiss()
                        
                    }) {
                        Image("finish")
                            .resizable()
                            .scaledToFit()
                    }
                default:
                    EmptyView()
                }
            }
        }
    }
    
    private func startWorkout() {
        presenter.startWorkout()
        stopWatchManager.start()
    }
    
    private func endWorkout() {
        print("end workout")
        presenter.endWorkout()
        stopWatchManager.stop()
    }
    
    private func pauseWorkout() {
        presenter.pauseWorkout()
        stopWatchManager.pause()
    }
    
    private func resumeWorkout() {
        presenter.resumeWorkout()
        stopWatchManager.resume()
    }
}

//struct WorkoutView_Previews: PreviewProvider {
//    static var previews: some View {
////        WorkoutView<Any>()
//
//    }
//}
