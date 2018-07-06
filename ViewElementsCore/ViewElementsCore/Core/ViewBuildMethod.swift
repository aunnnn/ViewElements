//
//  ViewBuildMethod.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import Foundation

/// How to build a view.
public enum ViewBuildMethod {

    /// .init()
    case `init`

    /// from nib with name as class name.
    case nib

    /// from nib with name.
    case nibWithName(String)
}
