//
//  ErrorView.swift
//  SwimTracker
//
//  Created by Zhanna Moskaliuk on 11.08.2022.
//

import SwiftUI

struct ErrorView: View {
    
    private let message: String
    
    init(errorMessage: String) {
        self.message = errorMessage
    }
    var body: some View {
        Text(message)
            .multilineTextAlignment(.center)
            .font(.title)
            .foregroundColor(.red)
    }
}

//struct ErrorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorView()
//    }
//}
