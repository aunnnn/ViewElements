//
//  BaseNibViewTests.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 9/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

class BaseNibViewTests: XCTestCase {

    func testDefaultBuildMethodMustBeNib() {
        let isBuildMethodNib = { () -> Bool in
            if case .nib = BaseNibView.buildMethod() {
                return true
            } else {
                return false
            }
        }()
        XCTAssertTrue(isBuildMethodNib)
    }

    func testBuildViewFromNib() {
        let el = ElementOf<TestBuildViewFromNib>(props: "Hello")
        let view = el.build()
        XCTAssert(view.didAwakeFromNibBlock != nil, "`didAwakeFromNibBlock` should be set for the built view from nib")
    }

    func testNibViewThatDoesNotInheritFromBaseNibViewMustCrash() {
        expectFatalError(expectedMessage: "A view instantiated from nib name \(InvalidNibView.self) must subclass from 'BaseNibView'.") {
            let el = ElementOf<InvalidNibView>(props: "Hello")
            _ = el.build()
        }
    }

    func testMustExecuteAwakeFromNibBlock() {
        let el = ElementOf<TestBuildViewFromNib>(props: "Hello")
        let view = el.build()
        XCTAssert(view.didAwakeFromNibBlock != nil)
        XCTAssertTrue(view.didAwakeFromNib)
        XCTAssertTrue(view.isAlreadyExecuteDidAwakeFromNibBlock)
        XCTAssertTrue(view.isSetUp)
    }
    
}
