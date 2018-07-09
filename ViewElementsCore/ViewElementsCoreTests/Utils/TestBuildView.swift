//
//  TestBuildView.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 9/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
import ViewElementsCore

class TestBuildView: UILabel, ElementableView {

    typealias PropsType = String

    let payload: String?

    static var currentBuildMethod: ViewBuildMethod = .frame(.zero)

    init(payload: String?) {
        self.payload = payload
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        Swift.fatalError("Should not call this")
    }

    override required init(frame: CGRect) {
        self.payload = "From frame"
        super.init(frame: frame)
    }

    func setup() {

    }

    func render(props: String) {
        text = props
    }

    class func buildMethod() -> ViewBuildMethod {
        return currentBuildMethod
    }
}
