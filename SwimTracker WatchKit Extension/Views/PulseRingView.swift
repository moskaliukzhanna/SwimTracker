//
//  PulseRingView.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 25.08.2022.
//

import Foundation
import SwiftUI

struct PulseRingView: View {
    @State var isOpen = false
    private var seconds: Double
    
    private let ringWidth: CGFloat
    private let colors: [Color]
    
    
    init(ringWidth: CGFloat = 10, foregroundColors: [Color] = [.white, .white], seconds: Double) {
        self.ringWidth = ringWidth
        self.colors = foregroundColors
        self.seconds = seconds
    }
    
    var ringGradient: AngularGradient {
        let gradient = createRingGradient(colors: colors)
        return gradient
    }
    
    var body: some View {
        RingShape()
            .stroke(style: StrokeStyle(lineWidth: self.ringWidth, lineCap: .round))
            .scale(self.isOpen ? 0.5 : 1.0)
            .fill(ringGradient)
            .frame(width: 80, height: 80, alignment: .center)
            .animation(.linear, value: self.isOpen)
            .onChange(of: seconds) { newValue in
                isOpen.toggle()
            }
    }
}
