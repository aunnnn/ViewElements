//
//  AnyElementTests.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 8/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

class AnyElementTests: XCTestCase {
    func testEqualityOfAnyElements() {
        let el1 = ElementOf<MockView>(props: "A").any
        let el2 = ElementOf<MockView>(props: "A").any
        let el3 = ElementOf<MockView>(props: "B").any
        XCTAssert(el1 == el2)
        XCTAssert(el1 != el3)
    }

    func testUnequaFromSamePropsButDifferentViewClasses() {
        let el1 = ElementOf<MockView>(props: "A").any
        let el2 = ElementOf<TestBuildView>(props: "A").any
        XCTAssert(el1 != el2)
    }

    func testPublicInterfaces() {
        let el1 = ElementOf<MockView>(props: "A").any

        XCTAssertTrue(el1.isPropsEqualTo(anotherProps: "A"))
        XCTAssertFalse(el1.isPropsEqualTo(anotherProps: "B"))
        XCTAssertFalse(el1.isPropsEqualTo(anotherProps: 2))

        let builtView = el1.build()
        XCTAssert(builtView is MockView)

        let mockView = builtView as! MockView
        el1.render(view: mockView, props: "Hello")
        XCTAssert(mockView.text == "Hello")
    }
}
