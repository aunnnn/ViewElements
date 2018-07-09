//
//  InvalidNibView.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 9/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
import ViewElementsCore

class InvalidNibView: UIView, ElementableView {
    typealias PropsType = String

    func setup() {

    }

    func render(props: String) {

    }

    static func buildMethod() -> ViewBuildMethod {
        return .nib
    }
}
