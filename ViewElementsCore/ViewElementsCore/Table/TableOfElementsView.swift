//
//  TableOfElementsView.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 6/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

/// A table view that knows how to interpret the `Table` model.
open class TableOfElementsView: UITableView {

    private enum Constants {
        static let defaultEstimatedRowHeight: CGFloat = 44
        static let defaultEstimatedHeaderFooterHeight: CGFloat = 44
    }

    fileprivate var displayedIndexPaths: Set<IndexPath> = []
    fileprivate var cellIDsToGuessedHeights: [String: CGFloat] = [:]

    public private(set) var table: Table

    public convenience init() {
        self.init(table: Table(rows: []))
    }

    public init(table: Table) {        
        self.table = table
        super.init(frame: .zero, style: .plain)
        setup()
    }

    public func setup() {
        dataSource = self
        delegate = self
    }

    public func reload(table: Table) {
        self.table = table
        setTableAppearance(table)
        reloadData()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("Should not instantiate `TableOfElementsView` from nib")
    }
}

// MARK:- Private
private extension TableOfElementsView {
    func setTableAppearance(_ table: Table) {
        if table.hidesTrailingSeparators {
            tableFooterView = UIView(frame: .zero)
        }
    }

    func getHeader(section: Int) -> SectionHeader? {
        return table.sections[section].header
    }

    func getFooter(section: Int) -> SectionFooter? {
        return table.sections[section].footer
    }

    func getHeaderFooterView(fromHeaderFooter headerFooter: SectionHeaderFooter, tableView: UITableView, section: Int) -> UIView {
        let element = headerFooter.anyElement
        let reuseId = element.identifier
        let v: TableSectionHeaderFooterView

        if let reusedHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseId) as? TableSectionHeaderFooterView {
            v = reusedHeader
        } else {
            v = TableSectionHeaderFooterView(headerFooter: headerFooter, reuseIdentifier: reuseId)
        }

        // It's not recommended to set backgroundColor of header footer view.
        v.preservesSuperviewLayoutMargins = false
        v.layoutMargins = .zero

        headerFooter.configure(container: v.contentView)
        return v

    }
}

// MARK:- UITableViewDataSource
extension TableOfElementsView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table.sections[section].rows.count
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return table.sections.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = table[indexPath]
        let cell: RowTableViewCell

        do /* Retrieving Cell */ {
            let reuseId = row.anyElement.identifier
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
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = getHeader(section: section) else { return nil }
        return getHeaderFooterView(fromHeaderFooter: header, tableView: tableView, section: section)
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = getFooter(section: section) else { return nil }
        return getHeaderFooterView(fromHeaderFooter: footer, tableView: tableView, section: section)
    }
}

// MARK:- UITableViewDelegate
extension TableOfElementsView: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var row = table[indexPath]
        let newEstimatedHeight = cell.bounds.height

        // This triggers cell update
        (cell as? RowTableViewCell)?.update(toRow: row)

        if table.updatesEstimatedRowHeights {
            if newEstimatedHeight < 1 {
                warn("Found new estimated height < 1 (\(newEstimatedHeight)) for view \(row.anyElement.identifier). This value will be ignored.")
                return
            } else {
                row.estimatedRowHeight = newEstimatedHeight
                table[indexPath] = row
            }
        }

        if table.guessesSameHeightsForCellsWithSameType {
            displayedIndexPaths.insert(indexPath)
            cellIDsToGuessedHeights[row.anyElement.identifier] = newEstimatedHeight
        }
    }

    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard var header = getHeader(section: section) else { return }
        (view as? TableSectionHeaderFooterView)?.update(toHeaderFooter: header)

        // Update estimated height
        guard table.updatesEstimatedHeaderFooterHeights else { return }
        let newEstimatedHeight = view.bounds.height
        header.estimatedHeaderFooterHeight = newEstimatedHeight
        table.sections[section].header = header
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard var footer = getFooter(section: section) else { return }
        (view as? TableSectionHeaderFooterView)?.update(toHeaderFooter: footer)

        // Update estimated height
        guard table.updatesEstimatedHeaderFooterHeights else { return }
        let newEstimatedHeight = view.bounds.height
        footer.estimatedHeaderFooterHeight = newEstimatedHeight
        table.sections[section].footer = footer
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = table[indexPath]
        let estimatedHeight = row.estimatedRowHeight ?? Constants.defaultEstimatedRowHeight

        guard table.guessesSameHeightsForCellsWithSameType else { return estimatedHeight }

        // if already displayed, use estimatedRowHeight
        if  displayedIndexPaths.contains(indexPath) {
            return estimatedHeight
        } else {
            return cellIDsToGuessedHeights[row.anyElement.identifier] ?? estimatedHeight
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return table[indexPath].rowHeight
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard let header = getHeader(section: section) else { return 0 }
        return header.estimatedHeaderFooterHeight ?? Constants.defaultEstimatedHeaderFooterHeight
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let header = getHeader(section: section) else { return 0 }
        return header.headerFooterHeight
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        guard let footer = getFooter(section: section) else { return 0 }
        return footer.estimatedHeaderFooterHeight ?? Constants.defaultEstimatedHeaderFooterHeight
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footer = getFooter(section: section) else { return 0 }
        return footer.headerFooterHeight
    }
}
