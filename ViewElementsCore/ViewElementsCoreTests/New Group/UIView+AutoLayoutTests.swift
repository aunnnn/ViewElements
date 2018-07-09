//
//  UIView+AutoLayoutTests.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 8/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
import ViewElementsCore

class UIViewAutoLayoutTests: XCTestCase {

    func testEdgesTo() {
        let root = UIView()
        let target = UIView()
        root.addSubview(target)

        XCTAssert(root.translatesAutoresizingMaskIntoConstraints == true)
        XCTAssert(root.translatesAutoresizingMaskIntoConstraints == true)

        let insets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        let priority = UILayoutPriority(123)
        target.al_edges(toView: root, insets: insets, priority: priority)

        XCTAssert(root.translatesAutoresizingMaskIntoConstraints == true, "`al_edges` should not change `translatesAutoresizingMaskIntoConstraints`of `toView`")
        XCTAssert(target.translatesAutoresizingMaskIntoConstraints == false, "`al_edges` should change  `translatesAutoresizingMaskIntoConstraints`of receiver view to `false`")
        XCTAssert(root.constraints.count == 4, "Root should have four constraints")
        XCTAssert(target.constraints.count == 0, "Target should have zero constraints")

        let doAllConstraintsHaveCorrectPriority = root.constraints.reduce(true, { (all, c) -> Bool in
            return all && (c.priority == priority)
        })

        let areAllConstraintsActive = root.constraints.reduce(true, { (all, c) -> Bool in
            return all && (c.isActive)
        })

        XCTAssert(doAllConstraintsHaveCorrectPriority, "All constraints should have priority of \(priority)")
        XCTAssert(areAllConstraintsActive, "All constraints should be active")

        let actualSetOfConstants = Set<CGFloat>(root.constraints.map { $0.constant })
        let expectedSetOfConstants = Set<CGFloat>([1, 2, -3, -4])
        XCTAssert(actualSetOfConstants == expectedSetOfConstants, "Wrong set of constants")
    }
}
