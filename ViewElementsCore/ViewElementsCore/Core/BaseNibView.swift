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
/// *IMPORTANT:* UIView that is initiated from nib file must have this as a base class (for it to work with the framework), as it performs some tasks on awakeFromNib.
open class BaseNibView: UIView {
    
    internal var didAwakeFromNibBlock: (() -> Void)? {
        didSet {
            // If at this time 'awakeFromNib' is already called, performs it directly here.
            if didAwakeFromNib {
                didAwakeFromNibBlock?()
            }
        }
    }
    
    private var didAwakeFromNib = false

    open override func awakeFromNib() {
        super.awakeFromNib()
        
        /*
            We can't be sure whether didAwakeFromNibBlock is set 
            before awakeFromNib() was called. But we must
            perform the block eventually, once. So keep
            track whether awakeFromNib is called.
         */
        
        didAwakeFromNibBlock?()
        didAwakeFromNib = true
    }

    open class func buildMethod() -> ViewBuildMethod {
        return .nib
    }
}
