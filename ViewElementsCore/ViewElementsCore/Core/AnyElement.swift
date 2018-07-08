//
//  AnyElement.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 6/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

public typealias AnyProps = Any

public extension ElementOf {
    var any: AnyElement {
        return AnyElement(self)
    }
}

public struct AnyElement: Equatable {
    let identifier: String
    let props: AnyProps
    private let _build: () -> UIView
    private let _render: (UIView) -> (AnyProps) -> Void
    private let _isPropsEqualToAnotherProps: (AnyProps) -> Bool

    init<T>(_ element: ElementOf<T>) {
        identifier = element.identifier
        props = element.props
        _build = element.build
        func render(view: UIView) -> (AnyProps) -> Void {
            return { [weak view] (anyProps: AnyProps) -> Void in
                guard let typedProps = anyProps as? T.PropsType else {
                    warn("Unexpected casting from props type \(type(of: anyProps)) to \(T.PropsType.self)")
                    return
                }
                guard let typedView = view as? T else {
                    warn("Unexpected casting from view type \(type(of: view)) to \(T.self)")
                    return
                }
                typedView.render(props: typedProps)
            }
        }

        func isPropsEqualTo(anotherProps: AnyProps) -> Bool {
            guard let typedAnotherProps = anotherProps as? T.PropsType else {
                warn("Expected received `anotherProps` to be \(T.PropsType.self), but actually is \(type(of: anotherProps)). \(element.identifier)")
                return false
            }
            return element.props == typedAnotherProps
        }

        _render = render(view:)
        _isPropsEqualToAnotherProps = isPropsEqualTo(anotherProps:)
    }

    func build() -> UIView {
        return _build()
    }

    func render(view: UIView, props: AnyProps) -> Void {
        _render(view)(props)
    }

    func isPropsEqualTo(anotherProps: AnyProps) -> Bool {
        return _isPropsEqualToAnotherProps(anotherProps)
    }

    public static func ==(lhs: AnyElement, rhs: AnyElement) -> Bool {
        return lhs.identifier == rhs.identifier
            && lhs.isPropsEqualTo(anotherProps: rhs.props)
    }
}
