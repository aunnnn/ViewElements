//
//  BaseNibView.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

/// Base UIView instantiated from nib in the ViewElements' ecosystem.
///
/// UIView that is initiated from nib file **must** have this as a base class (for it to work with the framework), as it performs some tasks on awakeFromNib.
///
/// **IMPORTANT**: If your nib name doesn't match the class name, `override
/// open class func buildMethod() -> ViewBuildMethod` too.
open class BaseNibView: UIView {

    // This should be set once (by the framework) on creating a new view instance.
    internal var didAwakeFromNibBlock: (() -> Void)? {
        didSet {
            // Block not nil, already awake, but has not called the block yet.
            if let block = didAwakeFromNibBlock, didAwakeFromNib, !isAlreadyExecuteDidAwakeFromNibBlock {
                block()
                isAlreadyExecuteDidAwakeFromNibBlock = true
            }
        }
    }

    internal private(set) var didAwakeFromNib = false
    internal private(set) var isAlreadyExecuteDidAwakeFromNibBlock = false

    open override func awakeFromNib() {
        super.awakeFromNib()
        didAwakeFromNib = true
        isAlreadyExecuteDidAwakeFromNibBlock = false
    }

    open class func buildMethod() -> ViewBuildMethod {
        return .nib
    }
}
