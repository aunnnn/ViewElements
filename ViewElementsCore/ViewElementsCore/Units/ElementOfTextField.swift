//
//  ElementOfTextField.swift
//  ViewElementsCore
//
//  Created by Wirawit Rueopas on 14/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

open class TextField: UITextField, ElementableView {
    public struct Props: Equatable {
        let placeholder: String?
        let text: String?
    }
    public typealias PropsType = Props

    open func setup() {}

    open func render(props: TextField.PropsType) {
        placeholder = props.placeholder
        text = props.text
    }

    open class func buildMethod() -> ViewBuildMethod {
        return .frame(.zero)
    }
}
