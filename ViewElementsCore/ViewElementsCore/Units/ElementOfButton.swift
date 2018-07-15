//
//  ElementOfButton.swift
//  ViewElementsCore
//
//  Created by Wirawit Rueopas on 14/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

public func ElementOfButton(_ props: Button.Props) -> ElementOf<Button> {
    return ElementOf<Button>(props: props)
}

open class Button: UIButton, ElementableView {
    public struct Props: Equatable {
        public let id: String
        public let image: UIImage?
        public let title: String?
        public let didTap: () -> Void

        public init(id: String, image: UIImage?, title: String?, didTap: @escaping () -> Void) {
            self.id = id
            self.image = image
            self.title = title
            self.didTap = didTap
        }
        public static func ==(lhs: Props, rhs: Props) -> Bool {
            return lhs.id == rhs.id
        }
    }
    public typealias PropsType = Props
    private var currentDidTapBlock: (() -> Void)?
    open func setup() {
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    open func render(props: Button.PropsType) {
        setTitle(props.title, for: .normal)
        setImage(props.image, for: .normal)
        currentDidTapBlock = props.didTap
    }

    @objc
    func didTap() {
        currentDidTapBlock?()
    }

    open class func buildMethod() -> ViewBuildMethod {
        return .frame(.zero)
    }
}
