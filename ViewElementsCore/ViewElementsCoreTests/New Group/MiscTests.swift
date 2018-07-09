//
//  MiscTests.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 8/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

class MiscTests: XCTestCase {
    
    func testRandomAlphaNumericProducesCorrectLength() {
        let actual1 = randomAlphaNumericString(length: 5)
        XCTAssertEqual(actual1.count, 5)

        let actual2 = randomAlphaNumericString(length: 12)
        XCTAssertEqual(actual2.count, 12)
    }
}
