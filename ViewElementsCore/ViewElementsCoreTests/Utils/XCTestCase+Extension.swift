//
//  XCTestCase+Extension.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 9/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import Foundation
import XCTest
@testable import ViewElementsCore

extension XCTestCase {
    func expectFatalError(expectedMessage: String,
                          customAssert: @escaping (_ actual: String, _ expected: String) -> Bool = { $0 == $1 },
                          testcase: @escaping () -> Void) {

        // arrange
        let expectation = self.expectation(description: "expectingFatalError")
        var assertionMessage: String? = nil

        // override fatalError. This will pause forever when fatalError is called.
        FatalErrorUtil.replaceFatalError { message, _, _ in
            assertionMessage = message
            expectation.fulfill()
            unreachable()
        }

        // act, perform on separate thead because a call to fatalError pauses forever
        DispatchQueue.global(qos: .userInitiated).async(execute: testcase)

        waitForExpectations(timeout: 1.0) { _ in
            defer {
                // clean up
                FatalErrorUtil.restoreFatalError()
            }

            guard let actualMessage = assertionMessage else {
                XCTFail("No fatalError detected.")
                return
            }
            
            // assert
            XCTAssert(customAssert(actualMessage, expectedMessage))
        }
    }
}
