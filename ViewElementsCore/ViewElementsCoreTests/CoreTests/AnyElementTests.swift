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

    func testEqualityofProperties() {
        let el = ElementOf<MockView>(props: "A")
        let anyEl = ElementOf<MockView>(props: "A").any
        XCTAssert(type(of: anyEl.props) == type(of: el.props))
        XCTAssert(type(of: anyEl.props) == MockView.PropsType.self)
        XCTAssert(anyEl.props as! MockView.PropsType == el.props)
        XCTAssert(el.identifier == anyEl.identifier)
    }

    func testBridgedElementFunctions() {
        let el1 = ElementOf<MockView>(props: "A").any

        XCTAssertTrue(el1.isPropsEqualTo(anotherProps: "A"))
        XCTAssertFalse(el1.isPropsEqualTo(anotherProps: "B"))
        XCTAssertFalse(el1.isPropsEqualTo(anotherProps: 2))

        let builtView = el1.build()
        XCTAssert(builtView is MockView)

        let mockView = builtView as! MockView
        el1.unsafeRender(view: mockView, props: "Hello")
        XCTAssert(mockView.text == "Hello")
    }

    func testRenderWrongPropsTypeShouldCrash() {
        expectFatalError(expectedMessage: "Unexpected casting from props type \(Int.self) to \(String.self)") {
            let mockViewElement = ElementOf<MockView>(props: "A").any
            let builtView = mockViewElement.build()
            mockViewElement.unsafeRender(view: builtView, props: 100)
        }
    }

    func testRenderWrongViewTypeShouldCrash() {
        expectFatalError(expectedMessage: "Unexpected casting from view type \(UIView.self) to \(MockView.self)") {
            let mockViewElement = ElementOf<MockView>(props: "A").any
            let wrongView = UIView()
            mockViewElement.unsafeRender(view: wrongView, props: "B")
        }
    }
}
