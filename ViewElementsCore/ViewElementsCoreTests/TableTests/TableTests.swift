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
}
