//
//  SectionTests.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 9/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

class SectionTests: XCTestCase {
    
    func testCreatingSectionWithoutHeaderOrFooter() {
        let el = ElementOf<MockView>(props: "Hello")
        let rows = [Row(el)]
        let section = Section(rows: rows)
        XCTAssert(section.rows == rows)
        XCTAssert(section.header == nil)
        XCTAssert(section.footer == nil)
    }

    func testCreatingSectionWithHeaderOrFooter() {
        let el = ElementOf<MockView>(props: "Hello")
        let rows = [Row(el)]
        let header = SectionHeader(el)
        let footer = SectionFooter(el)

        let section = Section(rows: rows, header: header, footer: footer)
        XCTAssert(section.rows == rows)
        XCTAssert(section.header == header)
        XCTAssert(section.footer == footer)
    }
}
