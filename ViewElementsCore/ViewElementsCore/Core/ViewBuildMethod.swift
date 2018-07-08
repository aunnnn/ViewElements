//
//  ViewBuildMethod.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

/// How to build a view.
public enum ViewBuildMethod {

    /// .init(frame: CGRect)
    case frame(CGRect)

    /// from nib with name as class name.
    case nib

    /// from nib with name.
    case nibWithName(String)

    /// Custom
    case custom(block: () -> UIView)
}
