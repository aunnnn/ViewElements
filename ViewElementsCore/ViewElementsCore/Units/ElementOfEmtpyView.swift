//
//  ElementOfEmtpyView.swift
//  ViewElementsCore
//
//  Created by Wirawit Rueopas on 14/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

public func RowOfEmptyView(height: CGFloat) -> Row {
    var row = Row(ElementOfEmptyView())
    row.rowHeight = height
    return row
}

func ElementOfEmptyView() -> ElementOf<EmptyView> {
    return ElementOf<EmptyView>(props: -1)
}

final class EmptyView: UIView, ElementableView {
    public typealias PropsType = (CGFloat)
    public func setup() {}
    public func render(props: EmptyView.PropsType) {}
    public static func buildMethod() -> ViewBuildMethod {
        return .frame(.zero)
    }
}
