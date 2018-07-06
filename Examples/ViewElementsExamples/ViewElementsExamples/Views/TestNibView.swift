//
//  TestNibView.swift
//  ViewElementsExamples
//
//  Created by Wirawit Rueopas on 6/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import ViewElements

class TestNibView: BaseNibView, ElementableView {

    typealias PropsType = String

    @IBOutlet weak var label: UILabel!

    func setup() {
        label.backgroundColor = .red
        label.textColor = .yellow
    }

    func render(props: String) {
        label.text = props
    }

    override class func buildMethod() -> ViewBuildMethod {
        return .nib
    }
}
