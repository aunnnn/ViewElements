//
//  UIView+AutoLayout.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 6/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

public extension UIView {

    /// Pin self to view's edges with inset.
    @discardableResult
    func al_edges(toView view: UIView, insets: UIEdgeInsets = .zero, priority: UILayoutPriority = .required) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ]
        constraints.forEach { (c) in
            c.priority = priority
        }
        NSLayoutConstraint.activate(constraints)
        return self
    }

    /// Pin self to view's margins guide.
    @discardableResult
    func al_edgesToLayoutMarginsGuide(toView view: UIView, priority: UILayoutPriority = .required) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.layoutMarginsGuide
        let constraints = [
            self.leftAnchor.constraint(equalTo: guide.leftAnchor),
            self.rightAnchor.constraint(equalTo: guide.rightAnchor),
            self.topAnchor.constraint(equalTo: guide.topAnchor),
            self.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ]
        constraints.forEach { (c) in
            c.priority = priority
        }
        NSLayoutConstraint.activate(constraints)
        return self
    }
}
