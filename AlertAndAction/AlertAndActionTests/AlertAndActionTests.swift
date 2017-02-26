//
//  AlertAndActionTests.swift
//  AlertAndActionTests
//
//  Created by Rajesh Billakanti on 25/02/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import XCTest
@testable import AlertAndAction

class AlertAndActionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        print("just before alertControllerAction method")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        print("just afetr alertControllerAction method")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
