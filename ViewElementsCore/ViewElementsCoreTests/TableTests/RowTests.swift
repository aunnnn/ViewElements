//
//  RowTests.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 9/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

class RowTests: XCTestCase {
    
    func testAnyElementOfRow() {
        let el = ElementOf<MockView>(props: "Hello")
        let row = Row(el)
        XCTAssert(row.anyElement == el.any)
    }

    func testRowIsValueType() {
        let el = ElementOf<MockView>(props: "Hello")
        var row1 = Row(el)
        row1.backgroundColor = .blue
        var row2 = row1
        row2.backgroundColor = .red

        XCTAssert(row1.backgroundColor == .blue)
        XCTAssert(row2.backgroundColor == .red)
    }

    func testDefaultRowProperties() {
        let el = ElementOf<MockView>(props: "Hello")
        let row = Row(el)

        XCTAssert(row.backgroundColor == .clear)
        XCTAssert(row.rowHeight == UITableViewAutomaticDimension)
        XCTAssert(row.estimatedRowHeight == nil)
        XCTAssert(row.isUserInteractionEnabled == true)
        XCTAssert(row.layoutMargins == .zero)
        XCTAssert(row.selectionStyle == .none)
        XCTAssert(row.separatorStyle == .hidden)
    }

    func testSettingRowProperties() {
        let el = ElementOf<MockView>(props: "Hello")
        var row = Row(el)
        row.backgroundColor = .red
        row.rowHeight = 100
        row.isUserInteractionEnabled = false
        row.layoutMargins = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        row.selectionStyle = .blue
        row.separatorStyle = .full

        XCTAssert(row.backgroundColor == .red)
        XCTAssert(row.rowHeight == 100)
        XCTAssert(row.estimatedRowHeight == 100)
        XCTAssert(row.isUserInteractionEnabled == false)
        XCTAssert(row.layoutMargins == UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4))
        XCTAssert(row.selectionStyle == .blue)
        XCTAssert(row.separatorStyle == .full)
    }

    func testSettingRowHeightAsFixedNumberShouldAlsoSetEstimatedHeight() {
        let el = ElementOf<MockView>(props: "Hello")
        var row = Row(el)
        row.rowHeight = 100
        XCTAssert(row.rowHeight == 100)
        XCTAssert(row.estimatedRowHeight == 100)
    }

    func testSeparatorStyleInsetsValue() {
        let full = SeparatorStyle.full
        let hidden = SeparatorStyle.hidden
        let custom = SeparatorStyle.insets(left: 2, right: 3)

        let cellBounds = CGRect(x: 0, y: 0, width: 300, height: 200)

        XCTAssert(full.value(withCellBounds: cellBounds) == .zero)
        XCTAssert(hidden.value(withCellBounds: cellBounds) == UIEdgeInsets(top: 0, left: cellBounds.width, bottom: 0, right: 0))
        XCTAssert(custom.value(withCellBounds: cellBounds) == UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 3))
    }

    func testRowCanConfigureView() {
        let el = ElementOf<MockView>(props: "Hello")
        var row = Row(el)
        row.backgroundColor = .yellow
        row.isUserInteractionEnabled = false
        row.layoutMargins = .init(top: 1, left: 2, bottom: 3, right: 4)

        let targetView = UIView()
        targetView.backgroundColor = .black
        targetView.isUserInteractionEnabled = true
        targetView.layoutMargins = .zero

        XCTAssert(targetView.backgroundColor == .black)
        XCTAssert(targetView.isUserInteractionEnabled == true)
        XCTAssert(targetView.layoutMargins == .zero)

        row.configure(container: targetView)

        XCTAssert(targetView.backgroundColor == .yellow)
        XCTAssert(targetView.isUserInteractionEnabled == false)
        XCTAssert(targetView.layoutMargins == UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4))
    }
}
