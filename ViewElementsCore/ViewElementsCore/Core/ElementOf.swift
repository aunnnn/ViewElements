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

/// UIView that is in the ViewElements' ecosystem.
public protocol ElementableView where Self: UIView {

    associatedtype PropsType: Props

    func setup()
    func render(props: PropsType)

    static func buildMethod() -> ViewBuildMethod
}

public extension ElementableView {
    static func buildMethod() -> ViewBuildMethod {
        return .init
    }
}

public extension ElementableView where Self: BaseNibView {
    static func buildMethod() -> ViewBuildMethod {
        return .nib
    }
}

public protocol Element {
    associatedtype View: ElementableView
    var props: View.PropsType { get }
    var viewIdentifier: String { get }
    func build() -> View
}

/// Element is a model that describes a view (`View`) together with its data (`PropsType`).
/// It's used to construct the actual view & filled in the data later by the framework.
public struct ElementOf<View: ElementableView>: Element {

    public typealias PropsType = View.PropsType

    /// Data for the view.
    public let props: PropsType

    private let uniqueID = randomAlphaNumericString(length: 10)

    /// The view's id. E.g., this will be a reuse id when displayed in table view cell.
    public var viewIdentifier: String {
        if stylesBlock != nil {
            return "\(View.self)\(uniqueID)"
        }
        return "\(View.self)"
    }

    public var stylesBlock: ((View) -> Void)?

    /// Additional styling to apply to view.
    public mutating func styles(_ block: @escaping (View) -> Void) -> ElementOf {
        self.stylesBlock = block
        return self
    }

    public init(props: PropsType) {
        self.props = props
    }

    public func build() -> View {
        switch View.buildMethod() {
        case .init:
            let view = View()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.setup()
            view.render(props: props)
            return view
        case .nib:
            return buildFromNib()
        case .nibWithName(let name):
            return buildFromNib(name: name)
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
            v.translatesAutoresizingMaskIntoConstraints = false
            v.setup()
            v.render(props: self.props)
        }
        return view
    }
}
