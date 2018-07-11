//
//  MockView.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 9/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

final class MockView: UILabel, ElementableView {

    typealias PropsType = String

    func setup() {

    }

    func render(props: String) {
        text = props
    }

    static func buildMethod() -> ViewBuildMethod {
        return .frame(.zero)
    }
}
