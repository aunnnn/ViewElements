//
//  ElementOfLabel.swift
//  ViewElementsCore
//
//  Created by Wirawit Rueopas on 14/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

public func ElementOfLabel(_ props: String) -> ElementOf<Label> {
    return ElementOf<Label>(props: props)
}

open class Label: UILabel, ElementableView {
    public typealias PropsType = String

    open func setup() {
        numberOfLines = 0
    }

    open func render(props: String) {
        text = props
    }

    open class func buildMethod() -> ViewBuildMethod {
        return .frame(.zero)
    }
}
