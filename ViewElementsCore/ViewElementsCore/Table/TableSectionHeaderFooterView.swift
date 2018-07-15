//
//  TableSectionHeaderView.swift
//  ViewElementsCore
//
//  Created by Wirawit Rueopas on 7/7/2561 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

internal class TableSectionHeaderFooterView: UITableViewHeaderFooterView {
    
    private var headerFooter: SectionHeaderFooter
    private weak var _elementView: UIView?
    
    init(headerFooter: SectionHeaderFooter, reuseIdentifier: String?) {
        self.headerFooter = headerFooter
        super.init(reuseIdentifier: reuseIdentifier)
        let view = headerFooter.anyElement.build()
        _elementView = view
        contentView.addSubview(view)
        view.al_edgesToLayoutMarginsGuide(ofView: contentView)

        // It's not recommended to set backgroundColor of header footer view, so we leave at the default value.
        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Initialising via storyboard is not suppported.")
    }

    func update(toHeaderFooter newHeaderFooter: SectionHeaderFooter) {
        // Set headerFooter at the end
        defer { headerFooter = newHeaderFooter }

        // Configure to headerfooter's styles
        newHeaderFooter.configure(container: contentView)
        
        let view = _elementView!
        if headerFooter.anyElement.isPropsEqualTo(anotherProps: newHeaderFooter.anyElement.props) {
            // If equal, do nothing
            return
        }
        newHeaderFooter.anyElement.unsafeRender(view: view, props: newHeaderFooter.anyElement.props)
    }
}
