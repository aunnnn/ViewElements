//
//  ElementableViewTests.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 8/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

class ElementableViewTests: XCTestCase {

    func testCustomizingViewRedBackground() {
        let el = ElementOf<TestCustomizingView>(props: "Test")
        let view = el.build()
        XCTAssert(view.payload == nil)
    }

    func testCustomizingViewIsCustomizedToBlueBackground() {
        let el = ElementOf<TestCustomizingView>(props: "Test").customized { (v) in
            v.payload = "Customized"
        }
        let view = el.build()
        XCTAssert(view.payload == "Customized")
    }

    func testDynamicViewIdentifier() {
        let el = ElementOf<TestCustomizingView>(props: "Test ID")
        XCTAssert(el.identifier == "Test ID")
    }

    func testDynamicViewIdentifierCustomized() {
        let actualID = ElementOf<TestCustomizingView>(props: "Test ID").customized { _ in }.identifier
        XCTAssert(actualID.contains("Test ID") && actualID != "TEST ID")
    }
}

class TestCustomizingView: UILabel, ElementableView {

    typealias PropsType = String

    var payload: String?

    func setup() {
        backgroundColor = .red
    }

    func render(props: String) {
        text = props
    }

    static func viewIdentifier(props: PropsType) -> String {
        return props
    }
}
