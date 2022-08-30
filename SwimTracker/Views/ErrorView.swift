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
        VStack {
            Image("norecords")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Spacer().frame(width: 20, height: 20, alignment: .center)
            Text(message)
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundColor(.red)
        }
    }
}

//struct ErrorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorView()
//    }
//}
