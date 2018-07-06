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

    private var row: Row
    private weak var _elementView: UIView?

    init(row: Row, reuseIdentifier: String) {
        self.row = row
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        let view = row.anyElement.build()
        _elementView = view
        contentView.addSubview(view)
        view.al_edgesToLayoutMarginsGuide(toView: contentView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(toRow newRow: Row) {
        defer {
            row = newRow
        }
        guard let view = _elementView else { return }
        if row.anyElement.isPropsEqualTo(anotherProps: newRow.anyElement.props) {
            // If equal, do nothing
            return
        }
        newRow.anyElement.render(view: view, props: newRow.anyElement.props)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        separatorInset = row.separatorStyle.value(withCellBounds: bounds)
    }
}
