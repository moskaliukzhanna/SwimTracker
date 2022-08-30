//
//  View+Additions.swift
//  SwimTracker WatchKit Extension
//
//  Created by Zhanna Moskaliuk on 29.08.2022.
//

import Foundation
import SwiftUI

extension View {
    func createRingGradient(colors: [Color],
                            gradientStartAngle: Double = 0.0,
                            relativePercentageAngle: Double = 0.0) -> AngularGradient {
        var ringGradient: AngularGradient {
            AngularGradient(
                gradient: Gradient(colors: colors),
                center: .center,
                startAngle: Angle(degrees: gradientStartAngle),
                endAngle: Angle(degrees: relativePercentageAngle)
            )
        }
        return ringGradient
    }
}
