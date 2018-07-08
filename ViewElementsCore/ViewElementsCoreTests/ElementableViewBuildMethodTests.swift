//
//  ElementableViewBuildMethodTests.swift
//  ViewElementsCoreTests
//
//  Created by Wirawit Rueopas on 8/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import ViewElementsCore

class ElementableViewBuildMethodTests: XCTestCase {

    func testBuildMethodInit() {
        TestBuildView.currentBuildMethod = .frame(.zero)
        let view = ElementOf<TestBuildView>(props: "Hello").build()
        XCTAssert(view.payload == "From frame")
    }

    func testBuildMethodCustom() {
        TestBuildView.currentBuildMethod = .custom(block: { () -> UIView in
            return TestBuildView(payload: "From custom")
        })
        let view = ElementOf<TestBuildView>(props: "Hello").build()
        XCTAssert(view.payload == "From custom")
    }

    func testBuildMethodNib() {
        TestBuildView.currentBuildMethod = .nib
        let view = ElementOf<TestBuildViewFromNib>(props: "Hello").build()
        XCTAssert(view.payload == "From nib")
    }

    func testBuildMethodNibWithName() {
        TestBuildView.currentBuildMethod = .nibWithName("TestBuildViewFromNibWithDifferentName")
        let view = ElementOf<TestBuildViewFromNib>(props: "Hello").build()
        XCTAssert(view.payload == "From nib")
    }
}


class TestBuildView: UILabel, ElementableView {
    
    typealias PropsType = String

    let payload: String?

    static var currentBuildMethod: ViewBuildMethod = .frame(.zero)

    init(payload: String?) {
        self.payload = payload
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Should not call this")
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

class TestBuildViewFromNib: BaseNibView, ElementableView {

    typealias PropsType = String

    var payload: String? = nil

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        payload = "From nib"
    }

    func setup() {
        
    }

    func render(props: TestBuildViewFromNib.PropsType) {

    }
}
