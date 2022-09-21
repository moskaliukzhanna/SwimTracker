//
//  StopWatchManager.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 15.08.2022.
//

import Foundation

enum StopWatchState {
    case stopped
    case runnning
    case paused
}

//protocol StopWatchManagerProtocol: ObservableObject {
//    var secondsElapsed: Double { get set }
//    var state: StopWatchState { get set }
//    func start()
//    func stop()
//    func pause()
//    func resume()
//}

final class StopWatchManager: ObservableObject {
    
    @Published var state: StopWatchState = .stopped
    @Published var secondsElapsed = 0.0
    private var timer = Timer()
    
    func start() {
        state = .runnning
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.secondsElapsed += 1.0
        }
    }
    
    func stop() {
        state = .stopped
        secondsElapsed = 0.0
        timer.invalidate()
    }
    
    func pause() {
        state = .paused
        timer.invalidate()
    }
    
    func resume() {
        state = .runnning
        start()
    }
}
