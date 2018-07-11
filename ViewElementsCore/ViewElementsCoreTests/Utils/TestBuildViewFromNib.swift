//
//  TestBuildViewFromNib.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 9/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

class TestBuildViewFromNib: BaseNibView, ElementableView {

    typealias PropsType = String

    var payload: String? = nil
    var isSetUp = false

    /// Set this before testing
    static var overiddenCustomNibNameForTesting: String? = nil

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if TestBuildViewFromNib.overiddenCustomNibNameForTesting != nil {
            payload = "From nib with custom class name"
        } else {
            payload = "From nib"
        }
    }

    func setup() {
        isSetUp = true
    }

    func render(props: TestBuildViewFromNib.PropsType) {

    }

    override class func buildMethod() -> ViewBuildMethod {
        guard let customName = TestBuildViewFromNib.overiddenCustomNibNameForTesting else {
            return super.buildMethod()
        }
        return .nibWithName(customName)
    }
}
