//
//  TableOfElementsViewTests.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 14/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

class TableOfElementsViewTests: XCTestCase {

    private func getMockElement(text: String) -> ElementOf<MockView> {
        return ElementOf<MockView>(props: text)
    }

    private func getMockTable(numberOfSections: Int) -> Table {
        func row(s: Int, r: Int) -> Row {
            return Row(getMockElement(text: "\(s),\(r)"))
        }
        let sections = (0..<numberOfSections).map { (s: Int) -> Section in
            var section = Section(rows: (0...s).map { (r: Int) -> Row in
                return row(s: s, r: r)
            })
            section.header = SectionHeader(getMockElement(text: "Header in section \(s)"))
            section.footer = SectionHeader(getMockElement(text: "Footer in section \(s)"))
            return section
        }
        return Table(sections: sections)
    }

    func testThatItselfIsDataSourceAndDelegate() {
        let tv = TableOfElementsView()
        XCTAssert(tv.delegate === tv)
        XCTAssert(tv.dataSource === tv)
    }

    func testDataSourceMethods() {
        let table = getMockTable(numberOfSections: 3)
        let tv = TableOfElementsView()
        tv.reload(table: table)

        let dataSource = tv.dataSource!
        XCTAssert(dataSource.numberOfSections!(in: tv) == 3)
        XCTAssert(dataSource.tableView(tv, numberOfRowsInSection: 0) == 1)
        XCTAssert(dataSource.tableView(tv, numberOfRowsInSection: 1) == 2)
        XCTAssert(dataSource.tableView(tv, numberOfRowsInSection: 2) == 3)

        let cell = dataSource.tableView(tv, cellForRowAt: .init(row: 1, section: 2))
        XCTAssert(cell.isKind(of: RowTableViewCell.self))

        let rowCell = cell as! RowTableViewCell
        XCTAssert(rowCell.contentView.subviews.count == 1, "Content of row cell must have one subview")

        let elementView = rowCell.contentView.subviews.first!
        XCTAssert(elementView.isKind(of: MockView.self), "Content of row cell must be 'MockView'")

        let mockView = elementView as! MockView
        XCTAssert(mockView.text == "2,1", "Text on 'MockView' must be '2,1'")

        // Check all cells content
        for s in (0..<3) {
            for r in (0...s) {
                let expectedCellText = "\(s),\(r)"
                let actualCellText = (dataSource.tableView(tv, cellForRowAt: .init(row: r, section: s)).contentView.subviews.first! as! MockView).text
                XCTAssertEqual(actualCellText, expectedCellText)
            }
        }
    }

    func testDelegateHeaderFooterViewMethods() {
        let table = getMockTable(numberOfSections: 3)
        let tv = TableOfElementsView()
        tv.reload(table: table)

        let delegate = tv.delegate!
        for s in (0..<3) {
            let expectedHeaderLabel = "Header in section \(s)"
            let actualHeaderLabel = ((delegate.tableView!(tv, viewForHeaderInSection: s)! as! UITableViewHeaderFooterView).contentView.subviews.first! as! MockView).text
            XCTAssertEqual(actualHeaderLabel, expectedHeaderLabel)

            let expectedFooterLabel = "Footer in section \(s)"
            let actualFooterLabel = ((delegate.tableView!(tv, viewForFooterInSection: s)! as! UITableViewHeaderFooterView).contentView.subviews.first! as! MockView).text
            XCTAssertEqual(actualFooterLabel, expectedFooterLabel)
        }
    }

    func testDelegateCellHeights() {
        var table = getMockTable(numberOfSections: 3)
        let tv = TableOfElementsView()
        tv.reload(table: table)
        let delegate = tv.delegate!

        let targetIndex = IndexPath(row: 0, section: 0)

        // Default heights
        XCTAssertEqual(delegate.tableView!(tv, heightForRowAt: targetIndex), UITableViewAutomaticDimension)
        XCTAssertEqual(delegate.tableView!(tv, estimatedHeightForRowAt: targetIndex), 44)

        // Custom heights
        table[targetIndex].estimatedRowHeight = 100
        tv.reload(table: table)
        XCTAssertEqual(delegate.tableView!(tv, estimatedHeightForRowAt: targetIndex), 100)

        table[targetIndex].rowHeight = 200
        tv.reload(table: table)
        XCTAssertEqual(delegate.tableView!(tv, heightForRowAt: targetIndex), 200)
        XCTAssertEqual(delegate.tableView!(tv, estimatedHeightForRowAt: targetIndex), 200) // Estimated height should also change
    }
}
