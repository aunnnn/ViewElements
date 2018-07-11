//
//  TableTests.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 11/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

class TableTests: XCTestCase {

    func testDefaultProperties() {
        let table = Table(rows: [])
        XCTAssertEqual(table.guessesSameHeightsForCellsWithSameType, false)
        XCTAssertEqual(table.hidesTrailingSeparators, true)
        XCTAssertEqual(table.updatesEstimatedHeaderFooterHeights, true)
        XCTAssertEqual(table.updatesEstimatedRowHeights, true)
        XCTAssertEqual(table.sections, [Section(rows: [])])
    }

    func testTableIsValueType() {
        let el = ElementOf<MockView>(props: "Hello")
        let row = Row(el)
        let table = Table(rows: [row])
        var copiedTable = table

        XCTAssertEqual(table, copiedTable)

        copiedTable.updatesEstimatedRowHeights = false

        XCTAssert(table != copiedTable)
        XCTAssert(table.updatesEstimatedRowHeights == true)
        XCTAssert(copiedTable.updatesEstimatedRowHeights == false)
    }

    func testCreateTableWithRowsMustHaveOneSection() {
        let el = ElementOf<MockView>(props: "Hello")
        let row = Row(el)
        let table = Table(rows: [row])
        XCTAssert(table.sections.count == 1)
        XCTAssert(table.sections.first?.rows.count == 1)
        XCTAssert(table.sections.first?.rows.first == row)

        let table2 = Table(sections: [Section(rows: [row])])
        XCTAssert(table == table2)
    }

    func testTableSubscript() {
        func row(num: Int) -> Row {
            return Row(ElementOf<MockView>(props: "\(num)"))
        }
        let s0 = Section(rows: [row(num: 0), row(num: 1)])
        let s1 = Section(rows: [row(num: 2), row(num: 3)])
        let table = Table(sections: [s0, s1])
        XCTAssert(table[IndexPath(row: 0, section: 0)] == row(num: 0))
        XCTAssert(table[IndexPath(row: 1, section: 0)] == row(num: 1))
        XCTAssert(table[IndexPath(row: 0, section: 1)] == row(num: 2))
        XCTAssert(table[IndexPath(row: 1, section: 1)] == row(num: 3))
    }
}
