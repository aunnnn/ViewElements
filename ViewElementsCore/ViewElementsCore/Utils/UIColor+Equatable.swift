//
//  UIColor+Equatable.swift
//  ViewElementsCore
//
//  Created by Wirawit Rueopas on 7/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

// More accurate equality for UIColor. This will override UIColor's default `==`
extension UIColor {
    public static func ==(lhs: UIColor, rhs: UIColor) -> Bool {
        var lhsR: CGFloat = 0
        var lhsG: CGFloat  = 0
        var lhsB: CGFloat = 0
        var lhsA: CGFloat  = 0
        lhs.getRed(&lhsR, green: &lhsG, blue: &lhsB, alpha: &lhsA)

        var rhsR: CGFloat = 0
        var rhsG: CGFloat  = 0
        var rhsB: CGFloat = 0
        var rhsA: CGFloat  = 0
        rhs.getRed(&rhsR, green: &rhsG, blue: &rhsB, alpha: &rhsA)

        return  lhsR == rhsR &&
            lhsG == rhsG &&
            lhsB == rhsB &&
            lhsA == rhsA
    }
}
