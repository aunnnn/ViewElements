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
        TestBuildView.currentBuildMethod = .frame(.zero)
        let view = ElementOf<TestBuildView>(props: "Hello").build()
        XCTAssert(view.payload == "From frame")
    }

    func testBuildMethodCustom() {
        TestBuildView.currentBuildMethod = .custom(block: { () -> UIView in
            return TestBuildView(payload: "From custom")
        })
        let view = ElementOf<TestBuildView>(props: "Hello").build()
        XCTAssert(view.payload == "From custom")
    }

    func testBuildMethodNib() {
        TestBuildView.currentBuildMethod = .nib
        let view = ElementOf<TestBuildViewFromNib>(props: "Hello").build()
        XCTAssert(view.payload == "From nib")
    }

    func testBuildMethodNibWithName() {
        TestBuildView.currentBuildMethod = .nibWithName("TestBuildViewFromNibWithDifferentName")
        let view = ElementOf<TestBuildViewFromNib>(props: "Hello").build()
        XCTAssert(view.payload == "From nib")
    }
}
