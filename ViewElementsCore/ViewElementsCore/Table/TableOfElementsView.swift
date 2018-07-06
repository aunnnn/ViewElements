//
//  TableOfElementsView.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 6/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

open class TableOfElementsView: UITableView {

    private enum Constants {
        static let defaultEstimatedRowHeight: CGFloat = 44
    }

    fileprivate var displayedIndexPaths: Set<IndexPath> = []
    fileprivate var cellIDsToGuessedHeights: [String: CGFloat] = [:]

    public private(set) var table: Table

    public init(table: Table) {        
        self.table = table
        super.init(frame: .zero, style: .plain)
        dataSource = self
        delegate = self
        setTableAppearance(table)
    }

    private func setTableAppearance(_ table: Table) {
        if table.hidesTrailingSeparators {
            tableFooterView = UIView(frame: .zero)
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("Should not instantiate `TableOfElementsView` from nib")
    }
}

extension TableOfElementsView: UITableViewDataSource {
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table.sections[section].rows.count
    }

    open func numberOfSections(in tableView: UITableView) -> Int {
        return table.sections.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = table[indexPath]
        let cell: RowTableViewCell

        do /* Retrieving Cell */ {
            let reuseId = row.anyElement.viewIdentifier
            if let reusedCell = tableView.dequeueReusableCell(withIdentifier: reuseId) as? RowTableViewCell {
                cell = reusedCell
            } else {
                cell = RowTableViewCell(row: row, reuseIdentifier: reuseId)
            }
        }

        // Reset root cell to default style. (margins = 0)
        cell.backgroundColor = row.backgroundColor
        cell.selectionStyle = row.selectionStyle
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = .zero

        // Reset content view to match the row styles.
        row.configure(container: cell.contentView)

        // This triggers cell update
        cell.update(toRow: row)
        return cell
    }
}

extension TableOfElementsView: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var row = table[indexPath]
        let newEstimatedHeight = cell.bounds.height

        if table.updatesEstimatedRowHeights {
            guard newEstimatedHeight >= 1 else {
                warn("Found new estimated height < 1 (\(newEstimatedHeight)) for view \(row.anyElement.viewIdentifier). This value will be ignored.")
                return
            }
            row.estimatedRowHeight = newEstimatedHeight
        }

        if table.guessesSameHeightsForCellsWithSameType {
            displayedIndexPaths.insert(indexPath)
            self.cellIDsToGuessedHeights[row.anyElement.viewIdentifier] = newEstimatedHeight
        }
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = table[indexPath]
        let estimatedHeight = row.estimatedRowHeight ?? Constants.defaultEstimatedRowHeight

        guard table.guessesSameHeightsForCellsWithSameType else { return estimatedHeight }

        // if already displayed, use estimatedRowHeight
        if  displayedIndexPaths.contains(indexPath) {
            return estimatedHeight
        } else {
            return cellIDsToGuessedHeights[row.anyElement.viewIdentifier] ?? estimatedHeight
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return table[indexPath].rowHeight
    }
}
