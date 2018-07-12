//
//  AnyElement.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 6/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

public typealias AnyProps = Any

public protocol AnyElementConvertible {
    var any: AnyElement { get }
}

extension ElementOf: AnyElementConvertible {
    public var any: AnyElement {
        return AnyElement(self)
    }
}

public struct AnyElement: Equatable {
    let identifier: String
    let props: AnyProps
    private let _build: () -> UIView
    private let _render: (_ anyView: UIView, _ anyProps: AnyProps) -> Void
    private let _isPropsEqualToAnotherProps: (AnyProps) -> Bool

    init<T>(_ element: ElementOf<T>) {
        identifier = element.identifier
        props = element.props
        _build = element.build
        
        func render(anyView: UIView, anyProps: Any) -> Void {
            guard let typedProps = anyProps as? T.PropsType else {
                fatalError("Unexpected casting from props type \(type(of: anyProps)) to \(T.PropsType.self)")
            }
            guard let typedView = anyView as? T else {
                fatalError("Unexpected casting from view type \(type(of: anyView)) to \(T.self)")
            }
            typedView.render(props: typedProps)
        }

        func isPropsEqualTo(anotherProps: AnyProps) -> Bool {
            guard let typedAnotherProps = anotherProps as? T.PropsType else {
                warn("Expected received `anotherProps` to be \(T.PropsType.self), but actually is \(type(of: anotherProps)). \(element.identifier)")
                return false
            }
            return element.props == typedAnotherProps
        }

        _render = render(anyView:anyProps:)
        _isPropsEqualToAnotherProps = isPropsEqualTo(anotherProps:)
    }

    func build() -> UIView {
        return _build()
    }

    /// Render any view with any props.
    ///
    /// **IMPORTANT:** `view` and `props` must be correct type for the wrapped element or it will crash.
    func unsafeRender(view: UIView, props: AnyProps) -> Void {
        _render(view, props)
    }

    func isPropsEqualTo(anotherProps: AnyProps) -> Bool {
        return _isPropsEqualToAnotherProps(anotherProps)
    }

    public static func ==(lhs: AnyElement, rhs: AnyElement) -> Bool {
        return lhs.identifier == rhs.identifier
            && lhs.isPropsEqualTo(anotherProps: rhs.props)
    }
}
