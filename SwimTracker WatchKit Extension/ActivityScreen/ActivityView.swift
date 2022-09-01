//
//  ActivityView.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 31.08.2022.
//

import Foundation
import SwiftUI

struct ActivityView<Manager>: View where Manager: StopWatchManagerProtocol {
    var presenter: ActivityPresenterProtocol
    @ObservedObject var stopWatchManager: Manager
    @Environment(\.dismiss) var dismiss
    @State private var isWorkoutView = true
    
    init() {
        stopWatchManager = StopWatchManager() as! Manager
        let manager = ActivityModel()
        presenter = ActivityPresenter(manager: manager)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text(String(format: "%.1f", stopWatchManager.secondsElapsed))
                    if isWorkoutView {
                        PulseRingView(foregroundColors: [.blue.opacity(0.8), .blue.opacity(0.5)],
                                      seconds: stopWatchManager.secondsElapsed)
                        .frame(width: 80, height: 80)
                    } else {
                        ActivityRingView(ringWidth: 10,
                                         percent: 5,
                                         backgroundColor: .purple.opacity(0.1),
                                         foregroundColors: [.purple, .pink])
                        .frame(width: 80, height: 80)
                        .previewLayout(.sizeThatFits)
                    }
                    Spacer()
                }
                
                .onTapGesture {
                    isWorkoutView.toggle()
                }
                
                VStack {
                    HStack {
                        switch stopWatchManager.state {
                        case .runnning:
                            Button(action: {
                                stopWatchManager.pause()
                                
                            }) {
                                Image("pause")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                            }
                        case .paused:
                            Button(action: {
                                endWorkSession()
                                
                            }) {
                                Image("finish")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                            }
                            Spacer().frame(width: 20, height: 20)
                            Button(action: { endWorkSession() }) {
                                Image("close")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                            }
                        default:
                            EmptyView()
                        }
                    }
                    HStack {
                        if stopWatchManager.state == .paused {
                            Button(action: { stopWatchManager.resume() }) {
                                
                                Image("swimming")
                                    .resizable()
                                    .frame(width: 25, height: 25, alignment: .center)
                            }
                        }
                    }
                }
                .frame(width: 120, height: 30)
            }
        }
        .onAppear {
            Task {
                let isAuthorized = await presenter.authorizeHealthKit()
                if isAuthorized {
                    stopWatchManager.start()
                }
            }
        }
        
        .onDisappear {
            presenter.stopWorkout(date: Date())
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
