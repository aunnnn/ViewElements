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

    func testThatMockTableHasCorrectSectionsAndRows() {
        let table = getMockTable(numberOfSections: 3)
        XCTAssertEqual(table.sections.count, 3)
        XCTAssertEqual(table.sections[0].rows.count, 1)
        XCTAssertEqual(table.sections[1].rows.count, 2)
        XCTAssertEqual(table.sections[2].rows.count, 3)
    }

    func testThatItselfIsDataSourceAndDelegate() {
        let tv = TableOfElementsView()
        XCTAssert(tv.delegate === tv)
        XCTAssert(tv.dataSource === tv)
    }

    func testDataSourceAndCellContents() {
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

    func testHeaderFooterViewContents() {
        let table = getMockTable(numberOfSections: 3)
        let tv = TableOfElementsView()
        tv.reload(table: table)

        let delegate = tv.delegate!

        // Check content
        for s in (0..<3) {
            let expectedHeaderLabel = "Header in section \(s)"
            let actualHeaderLabel = ((delegate.tableView!(tv, viewForHeaderInSection: s)! as! UITableViewHeaderFooterView).contentView.subviews.first! as! MockView).text
            XCTAssertEqual(actualHeaderLabel, expectedHeaderLabel)

            let expectedFooterLabel = "Footer in section \(s)"
            let actualFooterLabel = ((delegate.tableView!(tv, viewForFooterInSection: s)! as! UITableViewHeaderFooterView).contentView.subviews.first! as! MockView).text
            XCTAssertEqual(actualFooterLabel, expectedFooterLabel)
        }
    }

    func testHeaderViewHeights() {
        var table = getMockTable(numberOfSections: 3)
        let tv = TableOfElementsView()
        tv.reload(table: table)

        let delegate = tv.delegate!

        // Default heights
        XCTAssertEqual(delegate.tableView!(tv, estimatedHeightForHeaderInSection: 0), 44)
        XCTAssertEqual(delegate.tableView!(tv, heightForHeaderInSection: 0), UITableViewAutomaticDimension)

        // Change estimated height
        table.sections[0].header?.estimatedHeaderFooterHeight = 100
        tv.reload(table: table)
        XCTAssertEqual(delegate.tableView!(tv, estimatedHeightForHeaderInSection: 0), 100)
        XCTAssertEqual(delegate.tableView!(tv, heightForHeaderInSection: 0), UITableViewAutomaticDimension)

        // Change row height
        table.sections[0].header?.headerFooterHeight = 200
        tv.reload(table: table)
        XCTAssertEqual(delegate.tableView!(tv, estimatedHeightForHeaderInSection: 0), 200)
        XCTAssertEqual(delegate.tableView!(tv, heightForHeaderInSection: 0), 200)
    }

    func testFooterViewHeights() {
        var table = getMockTable(numberOfSections: 3)
        let tv = TableOfElementsView()
        tv.reload(table: table)

        let delegate = tv.delegate!

        // Default heights
        XCTAssertEqual(delegate.tableView!(tv, estimatedHeightForFooterInSection: 0), 44)
        XCTAssertEqual(delegate.tableView!(tv, heightForFooterInSection: 0), UITableViewAutomaticDimension)

        // Change estimated height
        table.sections[0].footer?.estimatedHeaderFooterHeight = 100
        tv.reload(table: table)
        XCTAssertEqual(delegate.tableView!(tv, estimatedHeightForFooterInSection: 0), 100)
        XCTAssertEqual(delegate.tableView!(tv, heightForFooterInSection: 0), UITableViewAutomaticDimension)

        // Change row height
        table.sections[0].footer?.headerFooterHeight = 200
        tv.reload(table: table)
        XCTAssertEqual(delegate.tableView!(tv, estimatedHeightForFooterInSection: 0), 200)
        XCTAssertEqual(delegate.tableView!(tv, heightForFooterInSection: 0), 200)
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

    func testWillDisplayCell() {
        var table = getMockTable(numberOfSections: 3)
        let tv = TableOfElementsView()
        tv.reload(table: table)
        let delegate = tv.delegate!

        let targetIndex = IndexPath(row: 0, section: 0)

        let cellUnderTest = RowTableViewCell(row: table[targetIndex], reuseIdentifier: "Test")

        // Edit content
        table[targetIndex] = Row(getMockElement(text: "New Row at 0,0"))

        // Reload
        tv.reload(table: table, thenReloadData: false)

        // This should update cell content to the current table
        delegate.tableView!(tv, willDisplay: cellUnderTest, forRowAt: targetIndex)

        let actualText = (cellUnderTest.contentView.subviews.first! as! MockView).text
        let expectedText = "New Row at 0,0"
        XCTAssertEqual(actualText, expectedText)
    }

    func testWillDisplayHeader() {
        var table = getMockTable(numberOfSections: 3)
        let tv = TableOfElementsView()
        tv.reload(table: table)
        let delegate = tv.delegate!

        let headerFooterUnderTest = TableSectionHeaderFooterView(headerFooter: table.sections[0].header!, reuseIdentifier: "Test")

        // Edit content
        table.sections[0].header = SectionHeaderFooter(getMockElement(text: "New Header at 0,0"))

        // Reload
        tv.reload(table: table, thenReloadData: false)

        // This should update header footer content to the current table
        delegate.tableView!(tv, willDisplayHeaderView: headerFooterUnderTest, forSection: 0)

        let actualText = (headerFooterUnderTest.contentView.subviews.first! as! MockView).text
        let expectedText = "New Header at 0,0"
        XCTAssertEqual(actualText, expectedText)
    }

    func testWillDisplayFooter() {
        var table = getMockTable(numberOfSections: 3)
        let tv = TableOfElementsView()
        tv.reload(table: table)
        let delegate = tv.delegate!

        let headerFooterUnderTest = TableSectionHeaderFooterView(headerFooter: table.sections[0].footer!, reuseIdentifier: "Test")

        // Edit content
        table.sections[0].footer = SectionHeaderFooter(getMockElement(text: "New Footer at 0,0"))

        // Reload
        tv.reload(table: table, thenReloadData: false)

        // This should update header footer content to the current table
        delegate.tableView!(tv, willDisplayFooterView: headerFooterUnderTest, forSection: 0)

        let actualText = (headerFooterUnderTest.contentView.subviews.first! as! MockView).text
        let expectedText = "New Footer at 0,0"
        XCTAssertEqual(actualText, expectedText)
    }

    func testGuessesCellHeights() {
        var table = getMockTable(numberOfSections: 3)
        table.guessesSameHeightsForCellsWithSameType = true
        let tv = TableOfElementsView()
        tv.reload(table: table)
        let delegate = tv.delegate!

        let targetIndex = IndexPath(row: 0, section: 0)
        let anotherIndex = IndexPath(row: 0, section: 1)

        // Default estimated height
        XCTAssertEqual(delegate.tableView!(tv, estimatedHeightForRowAt: anotherIndex), 44)

        let cellUnderTest = RowTableViewCell(row: table[targetIndex], reuseIdentifier: "Test")
        cellUnderTest.frame = .init(x: 0, y: 0, width: 300, height: 300)

        // This should update estimated height to 300
        delegate.tableView!(tv, willDisplay: cellUnderTest, forRowAt: targetIndex)

        // Guessing should work
        let estimatedHeight = delegate.tableView!(tv, estimatedHeightForRowAt: anotherIndex)
        XCTAssertEqual(estimatedHeight, 300)
    }

    func testUpdateEstimatedRowHeights() {
        let table = getMockTable(numberOfSections: 3)
        let tv = TableOfElementsView()
        tv.reload(table: table)
        let delegate = tv.delegate!

        let targetIndex = IndexPath(row: 0, section: 0)

        let cellUnderTest = RowTableViewCell(row: table[targetIndex], reuseIdentifier: "Test")
        cellUnderTest.frame = .init(x: 0, y: 0, width: 300, height: 300)

        // Previously should be nil
        XCTAssertNil(tv.table[targetIndex].estimatedRowHeight)
        XCTAssertEqual(tv.table[targetIndex].rowHeight, UITableViewAutomaticDimension)

        // This should update row's estimated height to 300
        delegate.tableView!(tv, willDisplay: cellUnderTest, forRowAt: targetIndex)

        // Estimated height should now be 300, rowHeight should be automatic (not change)
        XCTAssertEqual(tv.table[targetIndex].estimatedRowHeight, 300)
        XCTAssertEqual(tv.table[targetIndex].rowHeight, UITableViewAutomaticDimension)
    }
}
