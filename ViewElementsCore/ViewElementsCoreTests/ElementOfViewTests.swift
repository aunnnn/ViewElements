//
//  ElementOfViewTests.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 8/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

class ElementOfViewTests: XCTestCase {

    func testElementIdentifier() {
        let el = ElementOf<MockView>(props: "A")
        XCTAssert(el.identifier == "MockView")
    }

    func testElementProps() {
        let el = ElementOf<MockView>(props: "A")
        XCTAssert(el.props == "A")
    }

    func testElementsShouldEqualWhenViewAndPropsEqual() {
        let el1 = ElementOf<MockView>(props: "A")
        let el2 = ElementOf<MockView>(props: "A")
        let el3 = ElementOf<MockView>(props: "B")
        XCTAssert(el1 == el2)
        XCTAssert(el1 != el3)
    }

    func testElementsShouldNotEqualWhenItsCustomized() {
        let el = ElementOf<MockView>(props: "A")
        let elCustomized = ElementOf<MockView>(props: "A").customized { _ in }
        XCTAssert(el != elCustomized, "Customized element should not be equal with element of same props.")
        XCTAssert(el.identifier == "MockView")

        let containsOriginalViewButNotExactlyTheSame = elCustomized.identifier.contains("MockView") && elCustomized.identifier != "MockView"
        XCTAssert(containsOriginalViewButNotExactlyTheSame)
        XCTAssert(elCustomized.identifier.count == ("MockView".count + 6) , "Must include 6 random chars")
    }
}

final class MockView: UILabel, ElementableView {

    typealias PropsType = String

    func setup() {

    }

    func render(props: String) {
        text = props
    }
}
