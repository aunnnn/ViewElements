//
//  ElementContainer.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 6/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

/// Describe a container view that contains view built from Element.
protocol ElementContainer {

    /// Background color of container
    var backgroundColor: UIColor { get }

    var isUserInteractionEnabled: Bool { get }

    var layoutMargins: LayoutMargins { get }
}

extension ElementContainer {
    func configure(container view: UIView) {
        view.backgroundColor = backgroundColor
        view.isUserInteractionEnabled = isUserInteractionEnabled
        view.layoutMargins = layoutMargins
    }
}
