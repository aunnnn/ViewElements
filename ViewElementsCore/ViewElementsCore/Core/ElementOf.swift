//
//  ElementOf.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

/// Data that describes view.
public typealias Props = Equatable

/// Describe UIView in the ViewElements' ecosystem. UIView that can render `Props`.
public protocol ElementableView where Self: UIView {

    associatedtype PropsType: Props

    func setup()
    func render(props: PropsType)

    static func buildMethod() -> ViewBuildMethod

    /// By default it's just the view's class name. Override if you want it to depend on props.
    static func viewIdentifier(props: PropsType) -> String
}

public extension ElementableView {
    static func buildMethod() -> ViewBuildMethod {
        return .frame(.zero)
    }

    static func viewIdentifier(props: PropsType) -> String {
        return "\(Self.self)"
    }
}

public extension ElementableView where Self: BaseNibView {
    static func buildMethod() -> ViewBuildMethod {
        return .nib
    }
}

public protocol Element: Equatable {
    associatedtype View: ElementableView
    var props: View.PropsType { get }
    var identifier: String { get }
    func build() -> View
}

public extension Element {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.props == rhs.props
    }
}

/// Element is a model that describes a view (`View`) together with its data (`PropsType`).
/// It's used to construct the actual view & filled in the data later by the framework.
public struct ElementOf<View: ElementableView>: Element {

    public typealias PropsType = View.PropsType

    /// Data for the view.
    public let props: PropsType

    /// The view's id. E.g., this will be a reuse id when displayed in table view cell.
    public var identifier: String {
        let viewId = View.viewIdentifier(props: props)
        // If there's `uniqueID` (e.g., element is customized), append it.
        if let id = uniqueID {
            return "\(viewId)\(id)"
        }
        return viewId
    }

    /// Random id generated to specify that the element is unique (if needed).
    private var uniqueID: String?

    private var customizationBlock: ((View) -> Void)?

    /// Additional styling to apply to view. This always returns new instance of Element with the provided block.
    public func customized(_ block: @escaping (View) -> Void) -> ElementOf {
        // Generate unique Id if styles block is set
        var newElement = self
        newElement.uniqueID = randomAlphaNumericString(length: 6)
        newElement.customizationBlock = block
        return newElement
    }

    public init(props: PropsType) {
        self.props = props
    }

    public func build() -> View {
        switch View.buildMethod() {
        case .frame(let f):
            if false == View.instancesRespond(to: #selector(View.init(frame:))) {
                fatalError("`init(frame:)` not implemented but is called. You might have called this directly or indirectly (e.g., via using `.frame` for the ElementableView's buidMethod). If you implement custom initializer(s) for your UIView's subclass, make sure to override `init(frame:)`.")
            }
            let view = View(frame: f)
            setup(view)
            return view
        case .nib:
            return buildFromNib()
        case .nibWithName(let name):
            return buildFromNib(name: name)
        case .custom(let block):
            let _view = block()
            guard let view = _view as? View else {
                fatalError("Expected a view instantiated from custom block to have type \(View.self), but it actually is \(type(of: _view))")
            }
            setup(view)
            return view
        }
    }

    private func buildFromNib(name: String = "\(View.self)") -> View {
        guard let nib = Bundle(for: View.self).loadNibNamed(name, owner: nil, options: nil) else {
            fatalError("The nib with name '\(View.self)' is not found.")
        }
        let view = nib.first! as! View
        guard let baseNibView = view as? BaseNibView else {
            fatalError("A view instantiated from nib name \(name) must subclass from 'BaseNibView'.")
        }
        baseNibView.didAwakeFromNibBlock = { [weak view] in
            guard let v = view else { return }
            self.setup(v)
        }
        return view
    }

    private func setup(_ view: View) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setup()
        view.render(props: props)
    }
}
