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

    private func getMockTable(numberOfSections: Int) -> Table {
        func row(s: Int, r: Int) -> Row {
            return Row(ElementOf<MockView>(props: "\(s),\(r)"))
        }
        let sections = (0..<numberOfSections).map { s in
            Section(rows: (0...s).map { r in
                row(s: s, r: r)
            })
        }
        return Table(sections: sections)
    }

    func testThatItselfIsDataSourceAndDelegate() {
        let tv = TableOfElementsView()
        XCTAssert(tv.delegate === tv)
        XCTAssert(tv.dataSource === tv)
    }

    func testTableOfElementsViewDataSourceMethods() {
        let table = getMockTable(numberOfSections: 3)
        let tv = TableOfElementsView()
        tv.frame = .init(x: 0, y: 0, width: 300, height: 2000)
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
                let expectedLabelText = "\(s),\(r)"
                let actualView = dataSource.tableView(tv, cellForRowAt: .init(row: r, section: s)).contentView.subviews.first! as! MockView
                XCTAssert(actualView.text == expectedLabelText, "Cell content not match at \(s),\(r)")
            }
        }
    }
}
