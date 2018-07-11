//
//  SectionHeaderFooterTests.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 11/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

class SectionHeaderFooterTests: XCTestCase {

    func testAnyElementOfSectionHeaderFooter() {
        let el = ElementOf<MockView>(props: "Hello")

        let expected = el.any
        let actual = SectionHeaderFooter(el).anyElement
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(actual.props as! String, "Hello")
    }

    func testDefaultSectionHeaderFooterProperties() {
        let el = ElementOf<MockView>(props: "Hello")
        let s = SectionHeaderFooter(el)

        XCTAssert(s.backgroundColor == .clear)
        XCTAssert(s.isUserInteractionEnabled == true)
        XCTAssert(s.layoutMargins == .zero)
        XCTAssert(s.headerFooterHeight == UITableViewAutomaticDimension)
        XCTAssert(s.estimatedHeaderFooterHeight == nil)
    }

    func testSettingSectionHeaderFooterProperties() {
        let el = ElementOf<MockView>(props: "Hello")
        var s = SectionHeaderFooter(el)
        s.backgroundColor = .red
        s.isUserInteractionEnabled = false
        s.layoutMargins = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        s.headerFooterHeight = 100

        XCTAssert(s.backgroundColor == .red)
        XCTAssert(s.isUserInteractionEnabled == false)
        XCTAssert(s.layoutMargins == UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4))
        XCTAssert(s.headerFooterHeight == 100)
        XCTAssert(s.estimatedHeaderFooterHeight == 100)
    }

    func testSettingSectionHeaderFooterHeightAsFixedNumberShouldAlsoSetEstimatedHeight() {
        let el = ElementOf<MockView>(props: "Hello")
        var s = SectionHeaderFooter(el)
        s.headerFooterHeight = 100
        XCTAssert(s.headerFooterHeight == 100)
        XCTAssert(s.estimatedHeaderFooterHeight == 100)
    }

    func testSectionHeaderFooterIsValueType() {
        let el = ElementOf<MockView>(props: "Hello")
        var s = SectionHeaderFooter(el)
        s.backgroundColor = .blue
        var copiedS = s
        copiedS.backgroundColor = .red

        XCTAssert(s.backgroundColor == .blue)
        XCTAssert(copiedS.backgroundColor == .red)
    }

    func testSectionHeaderFooterCanConfigureView() {
        let el = ElementOf<MockView>(props: "Hello")
        var s = SectionHeaderFooter(el)
        s.backgroundColor = .yellow
        s.isUserInteractionEnabled = false
        s.layoutMargins = .init(top: 1, left: 2, bottom: 3, right: 4)

        let targetView = UIView()
        targetView.backgroundColor = .black
        targetView.isUserInteractionEnabled = true
        targetView.layoutMargins = .zero

        XCTAssert(targetView.backgroundColor == .black)
        XCTAssert(targetView.isUserInteractionEnabled == true)
        XCTAssert(targetView.layoutMargins == .zero)

        s.configure(container: targetView)

        XCTAssert(targetView.backgroundColor == .yellow)
        XCTAssert(targetView.isUserInteractionEnabled == false)
        XCTAssert(targetView.layoutMargins == UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4))
    }
}
