//
//  StackOfElementsView.swift
//  ViewElementsCore
//
//  Created by Wirawit Rueopas on 8/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

/// Model of stack
public struct Stack: Equatable, ElementContainer {
    typealias Element = AnyElementConvertible

    let elements: [AnyElement]
    public var layout: Layout = Layout(axis: .horizontal, distribution: .fill, alignment: .top, spacing: 0)

    // MARK: ElementContainer's
    public var backgroundColor: UIColor = .clear
    public var isUserInteractionEnabled: Bool = true
    public var layoutMargins: LayoutMargins = .zero

    public init(_ elements: [AnyElementConvertible]) {
        self.elements = elements.map { $0.any }
    }

    public struct Layout: Equatable {
        public var axis: UILayoutConstraintAxis
        public var distribution: UIStackViewDistribution
        public var alignment: UIStackViewAlignment
        public var spacing: CGFloat
    }
}

open class StackOfElementsView: UIView, ElementableView {

    public typealias PropsType = Stack
    private var prevProps: Stack?
    private lazy var stackView = UIStackView()

    /// We implement stack id based on props here.
    /// Because all components share the same stack view, with different Stack content.
    public static func viewIdentifier(props: PropsType) -> String {
        let allElementsID = props.elements.map { $0.identifier }.joined(separator: "|")
        return "[\(allElementsID)]"
    }

    public func setup() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.al_edgesToLayoutMarginsGuide(ofView: self)
    }

    public func render(props: Stack) {

        // Setup backgroundColor, layoutMargins etc.
        props.configure(container: self)

        let needsUpdateStructure: Bool
        let needsLayoutUpdate: Bool
        let needsPropsUpdate: Bool

        if let prevProps = prevProps {
            if StackOfElementsView.needsUpdateManagedElements(from: prevProps, toRender: props) {
                // Update everything when views don't match
                // TODO: Think about common usecases and make it more efficient (like React)
                needsUpdateStructure = true
                needsLayoutUpdate = true
                needsPropsUpdate = true
            }
            else if StackOfElementsView.needsUpdateStackViewLayout(from: prevProps, toRender: props) {
                // No structural change, but layout update, check if props need update
                needsUpdateStructure = false
                needsLayoutUpdate = true
                needsPropsUpdate = StackOfElementsView.needsUpdateProps(from: prevProps, toRender: props)
            }
            else if StackOfElementsView.needsUpdateProps(from: prevProps, toRender: props) {
                // No structural change, no layout change, but props change
                needsUpdateStructure = false
                needsLayoutUpdate = false
                needsPropsUpdate = true
            }
            else {
                // Nothing changes
                needsUpdateStructure = false
                needsLayoutUpdate = false
                needsPropsUpdate = false
            }
        } else {
            // No prev props, do everything
            needsUpdateStructure = true
            needsLayoutUpdate = true
            needsPropsUpdate = true
        }
        if needsUpdateStructure {
            stackView.arrangedSubviews.forEach { (v) in
                stackView.removeArrangedSubview(v)
                v.removeFromSuperview()
            }
            props.elements.forEach { (e) in
                stackView.addArrangedSubview(e.build())
            }
        }
        if needsLayoutUpdate {
            updateStackLayout(props.layout)
        }
        if needsPropsUpdate {
            updateViewProps(props, noStructureChanged: !needsUpdateStructure)
        }
        prevProps = props
        print("""
            Render \(StackOfElementsView.viewIdentifier(props: props))
            Structure change?\(needsUpdateStructure)
            Layout change?\(needsLayoutUpdate)
            Props change?\(needsPropsUpdate)
            -------------------------------------------
            """)
    }

    private func updateStackLayout(_ layout: Stack.Layout) {
        stackView.axis = layout.axis
        stackView.distribution = layout.distribution
        stackView.alignment = layout.alignment
        stackView.spacing = layout.spacing
    }

    private func updateViewProps(_ props: PropsType, noStructureChanged: Bool) {
        if let prev = prevProps, noStructureChanged {
            // If no structural change, we can check if each views need rerender or not.
            (0..<props.elements.count).forEach { (i) in
                let el = props.elements[i]
                let pel = prev.elements[i]
                let v = stackView.arrangedSubviews[i]
                if el.isPropsEqualTo(anotherProps: pel.props) {
                    return
                } else {
                    el.unsafeRender(view: v, props: el.props)
                }
            }
        } else {
            zip(props.elements, stackView.arrangedSubviews).forEach { (el, v) in
                el.unsafeRender(view: v, props: el.props)
            }
        }
    }

    private static func needsUpdateManagedElements(from: Stack, toRender to: Stack) -> Bool {
        // Structural change?
        if from.elements.count != to.elements.count { return true }
        return zip(from.elements, to.elements).first(where: { $0.0.identifier != $0.1.identifier }) != nil
    }

    private static func needsUpdateStackViewLayout(from: Stack, toRender to: Stack) -> Bool {
        // Layout change?
        return from.layout != to.layout
    }

    private static func needsUpdateProps(from: Stack, toRender to: Stack) -> Bool {
        // Props change?
        if from.elements.count != to.elements.count { return true }
        return zip(from.elements, to.elements).first(where: { !$0.0.isPropsEqualTo(anotherProps: $0.1.props) }) != nil
    }

    public static func buildMethod() -> ViewBuildMethod {
        return .frame(.zero)
    }
}
