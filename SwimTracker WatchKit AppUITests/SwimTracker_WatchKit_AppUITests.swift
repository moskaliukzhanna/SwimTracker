//
//  SwimTracker_WatchKit_AppUITests.swift
//  SwimTracker WatchKit AppUITests
//
//  Created by Zhanna Moskaliuk on 18.08.2022.
//

import XCTest

class SwimTracker_WatchKit_AppUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override class func setUp() {
        super.setUp()
    }
    
    func testLaunch() {
        app.launch()
        app.buttons["Swim"].tap()
    }
}
