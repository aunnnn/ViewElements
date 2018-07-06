//
//  AnyElement.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 6/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

typealias AnyProps = Any

struct AnyElement {
    let viewIdentifier: String
    let props: AnyProps
    private let _build: () -> UIView
    private let _renderForView: (UIView) -> (AnyProps) -> Void
    private let _isPropsEqualToAnotherProps: (AnyProps) -> Bool

    init<T>(_ element: ElementOf<T>) {
        viewIdentifier = element.viewIdentifier
        props = element.props
        _build = element.build
        _renderForView = { (view: UIView) -> (AnyProps) -> Void in
            return { [weak view] (anyProps: AnyProps) -> Void in
                guard let typedProps = anyProps as? T.PropsType else {
                    fatalError("Unexpected casting from props type \(type(of: anyProps)) to \(T.PropsType.self)")
                }
                guard let typedView = view as? T else {
                    fatalError("Unexpected casting from view type \(type(of: view)) to \(T.self)")
                }
                typedView.render(props: typedProps)
            }
        }
        _isPropsEqualToAnotherProps = { (anotherProps: AnyProps) -> Bool in
            guard let typedAnotherProps = anotherProps as? T.PropsType else {
                fatalError("Expected received `anotherProps` to be \(T.PropsType.self), but actually is \(type(of: anotherProps))")
            }
            return element.props == typedAnotherProps
        }
    }

    func build() -> UIView {
        return _build()
    }

    func render(view: UIView, props: AnyProps) -> Void {
        _renderForView(view)(props)
    }

    func isPropsEqualTo(anotherProps: AnyProps) -> Bool {
        return _isPropsEqualToAnotherProps(anotherProps)
    }
}
