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
    func al_edges(toView view: UIView, insets: UIEdgeInsets = .zero) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ]
        NSLayoutConstraint.activate(constraints)
        return self
    }

    /// Pin self to view's margins guide.
    @discardableResult
    func al_edgesToLayoutMarginsGuide(toView view: UIView) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.layoutMarginsGuide
        self.leftAnchor.constraint(equalTo: guide.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: guide.rightAnchor).isActive = true
        self.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        return self
    }
}
