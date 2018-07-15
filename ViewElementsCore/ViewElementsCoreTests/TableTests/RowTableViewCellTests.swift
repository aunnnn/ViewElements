//
//  RowTableViewCellTests.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 15/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

class RowTableViewCellTests: XCTestCase {
    
    func testItShouldNotInitFromCoder() {
        expectFatalError(expectedMessage: "Must initialize from code.") {
            let coder = NSCoder()
            _ = RowTableViewCell(coder: coder)
        }
    }

    func testItShouldHaveCorrectDefaultStyle() {
        let el = ElementOf<MockView>(props: "Hello")
        var row = Row(el)
        row.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
        row.backgroundColor = .green
        row.separatorStyle = .hidden
        let cell = RowTableViewCell(row: row, reuseIdentifier: "test")
        cell.update(toRow: row)
        cell.setNeedsLayout()
        cell.layoutSubviews()
        XCTAssertEqual(cell.layoutMargins, .zero)
        XCTAssertEqual(cell.separatorInset, UIEdgeInsets.init(top: 0, left: cell.bounds.width, bottom: 0, right: 0))
        XCTAssertEqual(cell.preservesSuperviewLayoutMargins, false)
        XCTAssertEqual(cell.backgroundColor, .green, "Root view should initially be set to row's backgroundColor")
    }

    func testItShouldSeparatorInsetsCorrectly() {
        let el = ElementOf<MockView>(props: "Hello")
        var row = Row(el)
        row.layoutMargins = .zero // Important, if not set to zero, it will adjust the final value of 'separatorInset'
        row.separatorStyle = .insets(left: 1, right: 1)
        let cell = RowTableViewCell(row: row, reuseIdentifier: "test")
        cell.update(toRow: row)s
        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        XCTAssertEqual(cell.layoutMargins, .zero)
        XCTAssertEqual(cell.separatorInset, .init(top: 0, left: 1, bottom: 0, right: 1))

        row.separatorStyle = .insets(left: 10, right: 20)
        cell.update(toRow: row)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        XCTAssertEqual(cell.separatorInset, .init(top: 0, left: 10, bottom: 0, right: 20))
    }
}
