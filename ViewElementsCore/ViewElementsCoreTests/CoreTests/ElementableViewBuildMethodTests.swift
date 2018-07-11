//
//  ElementableViewBuildMethodTests.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 8/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

class ElementableViewBuildMethodTests: XCTestCase {

    func testBuildMethodInit() {
        // Must override init(frame:)!
        TestBuildView.currentBuildMethod = .frame(.init(x: 0, y: 1, width: 2, height: 3))
        let view = ElementOf<TestBuildView>(props: "Hello").build()
        XCTAssert(view.payload == "From frame")
        XCTAssert(view.frame == .init(x: 0, y: 1, width: 2, height: 3))
    }

    func testBuildMethodCustom() {
        TestBuildView.currentBuildMethod = .custom(block: { () -> UIView in
            return TestBuildView(payload: "From custom")
        })
        let view = ElementOf<TestBuildView>(props: "Hello").build()
        XCTAssert(view.payload == "From custom")
    }

    func testBuildMethodNibWithViewClassName() {
        TestBuildViewFromNib.overiddenCustomNibNameForTesting = nil // This will use default name, which is the view's class name
        let view = ElementOf<TestBuildViewFromNib>(props: "Hello").build()
        XCTAssert(view.payload == "From nib")
    }

    func testBuildMethodNibWithName() {
        TestBuildViewFromNib.overiddenCustomNibNameForTesting = "TestBuildViewFromNibWithDifferentName"
        let view = ElementOf<TestBuildViewFromNib>(props: "Hello").build()
        XCTAssert(view.payload == "From nib with custom class name")
    }

    func testBuildMethodCustomBlockThatReturnWrongViewTypeShouldCrash() {
        expectFatalError(expectedMessage: "Expected a view instantiated from custom block to have type \(TestBuildView.self), but it actually is \(UIView.self)") {
            TestBuildView.currentBuildMethod = .custom(block: { () -> UIView in
                return UIView()
            })
            _ = ElementOf<TestBuildView>(props: "Hello").build()
        }
    }
}
