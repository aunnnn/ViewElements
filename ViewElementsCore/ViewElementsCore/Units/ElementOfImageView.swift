//
//  ElementOfImageView.swift
//  ViewElementsCore
//
//  Created by Wirawit Rueopas on 14/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

public func ElementOfImageView(_ props: UIImage) -> ElementOf<ImageView> {
    return ElementOf<ImageView>(props: props)
}

open class ImageView: UIImageView, ElementableView {
    public typealias PropsType = UIImage

    open func setup() {
        contentMode = .scaleAspectFit
        clipsToBounds = true
        isUserInteractionEnabled = false
    }

    open func render(props: UIImage) {
        self.image = props
    }

    open class func buildMethod() -> ViewBuildMethod {
        return .frame(.zero)
    }
}
