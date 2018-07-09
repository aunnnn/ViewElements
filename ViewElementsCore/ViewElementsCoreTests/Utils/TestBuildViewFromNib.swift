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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        payload = "From nib"
    }

    func setup() {
        isSetUp = true
    }

    func render(props: TestBuildViewFromNib.PropsType) {

    }
}
