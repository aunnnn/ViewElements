//
//  RowTableViewCell.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

/// Table view cell that wraps view built from element.
final class RowTableViewCell: UITableViewCell {

    private var row: Row?
    private weak var _elementView: UIView?

    /// Create a template cell with view from `row`.
    /// Note that this doesn't set the `row` property yet. Call `update(toRow:)` again.
    init(row: Row, reuseIdentifier: String) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        let view = row.anyElement.build()
        _elementView = view
        contentView.addSubview(view)
        view.al_edgesToLayoutMarginsGuide(ofView: contentView)

        // Default root view style
        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Must initialize from code.")
    }

    func update(toRow newRow: Row) {
        // Set row at the end
        defer { row = newRow }

        // Configure root
        backgroundColor = newRow.backgroundColor
        selectionStyle = newRow.selectionStyle
        separatorInset = newRow.separatorStyle.value(withCellBounds: bounds)

        // Configure to row's styles
        newRow.configure(container: contentView)

        let view = _elementView!
        if let row = row, row.anyElement.isPropsEqualTo(anotherProps: newRow.anyElement.props) {
            // There's 'row' and it is already equal to 'newRow' -> do nothing
            return
        } else {
            newRow.anyElement.unsafeRender(view: view, props: newRow.anyElement.props)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Always rely on latest 'bounds' value.
        if let inset = row?.separatorStyle.value(withCellBounds: bounds) {
            separatorInset = inset
        }
    }
}
