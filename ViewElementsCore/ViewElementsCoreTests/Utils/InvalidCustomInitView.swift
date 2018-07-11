//
//  InvalidCustomInitView.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 10/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

// TODO: Figure out how to test this, how to handle this case and explain to the user of the framework.
class InvalidCustomInitView: UIView, ElementableView {

    typealias PropsType = Int

    let payload: String

    init(payload: String) {
        self.payload = payload
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        Swift.fatalError("Should not call this")
    }

    func setup() {}
    func render(props: InvalidCustomInitView.PropsType) {}

    // We shouldn't use `.frame(CGRect)` as a buildMethod here (the default value).
    // This should cause a crash in tests.
    static func buildMethod() -> ViewBuildMethod {
        return .frame(.zero)
    }
}
