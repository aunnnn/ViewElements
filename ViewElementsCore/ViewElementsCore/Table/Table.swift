//
//  Table.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

public typealias LayoutMargins = UIEdgeInsets
public enum SeparatorStyle: Equatable {
    case hidden
    case full
    case insets(left: CGFloat, right: CGFloat)

    internal func value(withCellBounds cellBounds: CGRect) -> UIEdgeInsets {
        switch self {
        case .hidden:
            return UIEdgeInsets(top: 0, left: cellBounds.width, bottom: 0, right: 0)
        case .full:
            return UIEdgeInsets.zero
        case let .insets(left, right):
            return UIEdgeInsets(top: 0, left: left, bottom: 0, right: right)
        }
    }
}

public struct Row: ElementContainer {

    internal let anyElement: AnyElement

    // MARK: ElementContainer's
    public var backgroundColor: UIColor = .clear
    public var isUserInteractionEnabled: Bool = true
    public var layoutMargins: LayoutMargins = .zero

    // MARK: Row's
    public var selectionStyle: UITableViewCellSelectionStyle = .none
    public var separatorStyle: SeparatorStyle = .hidden

    /// `estimatedRowHeight` will also get updated as cell is displayed to reflect latest (most accurate) height value.
    public var estimatedRowHeight: CGFloat?
    public var rowHeight: CGFloat = UITableViewAutomaticDimension {
        didSet {
            // if not fixed height, also set estimatedRowHeight to rowHeight
            if hasFixedHeight {
                estimatedRowHeight = rowHeight
            }
        }
    }

    private var hasFixedHeight: Bool {
        return rowHeight != UITableViewAutomaticDimension
    }

    public init<T>(_ element: ElementOf<T>) {
        anyElement = AnyElement(element)
    }
}

public struct SectionHeaderFooter: ElementContainer {

    internal let anyElement: AnyElement

    // MARK: ElementContainer's
    public var backgroundColor: UIColor = .clear
    public var isUserInteractionEnabled: Bool = true
    public var layoutMargins: LayoutMargins = .zero

    public var estimatedHeaderFooterHeight: CGFloat?
    public var headerFooterHeight: CGFloat = UITableViewAutomaticDimension {
        didSet {
            if hasFixedHeight {
                estimatedHeaderFooterHeight = headerFooterHeight
            }
        }
    }

    private var hasFixedHeight: Bool {
        return headerFooterHeight != UITableViewAutomaticDimension
    }

    public init<T>(_ element: ElementOf<T>) {
        anyElement = AnyElement(element)
    }
}

/// Both share the same model
public typealias SectionHeader = SectionHeaderFooter
public typealias SectionFooter = SectionHeaderFooter

public struct Section: Equatable {
    public var header: SectionHeader?
    public var footer: SectionFooter?
    public var rows: [Row]

    public init(rows: [Row],
                header: SectionHeader? = nil,
                footer: SectionFooter? = nil) {
        self.rows = rows
        self.header = header
        self.footer = footer
    }
}

public struct Table: Equatable {
    
    public var sections: [Section]

    /// If `true` (default), each FormRow's estimatedRowHeight will be updated with actual value after displaying the cell. If your cell heights are changing frequently, then you might want to set this to `false`.
    public var updatesEstimatedRowHeights: Bool = true
    public var updatesEstimatedHeaderFooterHeights: Bool = true

    /// Default is `false`. If `true`, a row height of previously displayed cells will be used as `estimatedRowHeight` of subsequent cells with the same reuseID.
    ///
    /// This is useful when we don't set estimatedRowHeight manually.
    public var guessesSameHeightsForCellsWithSameType: Bool = false

    /// If `true` (default), hide the trailing separators in the table view.
    public var hidesTrailingSeparators: Bool = true

    public subscript(indexPath: IndexPath) -> Row {
        get {
            return sections[indexPath.section].rows[indexPath.row]
        }
        set {
            sections[indexPath.section].rows[indexPath.row] = newValue
        }
    }

    public init(sections: [Section]) {
        self.sections = sections
    }

    public init(rows: [Row]) {
        self.init(sections: [Section(rows: rows)])
    }
}
