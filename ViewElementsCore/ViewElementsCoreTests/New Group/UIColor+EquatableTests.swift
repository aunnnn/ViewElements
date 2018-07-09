//
//  UIColor+EquatableTests.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 8/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest

class UIColorEquatableTests: XCTestCase {
    
    func testRedEqualsRedFromDifferentInitializationMethods() {
        let red1 = UIColor.red
        let red2 = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        XCTAssertTrue(red1 == red2)
    }

    func testRedNotEqualAnotherRedWithDifferentAlphas() {
        let red1 = UIColor.red.withAlphaComponent(0.3)
        let red2 = UIColor(red: 1, green: 0, blue: 0, alpha: 0.3)
        XCTAssertTrue(red1 == red2)
    }
}
