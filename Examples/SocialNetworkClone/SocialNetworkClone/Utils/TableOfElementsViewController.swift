//
//  TableOfElementsViewController.swift
//  SocialNetworkClone
//
//  Created by Wirawit Rueopas on 14/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit
import ViewElementsCore

class TableOfElementsViewController: UIViewController {

    var table: Table? {
        didSet {
            if let table = table {
                tableView.reload(table: table)
            } else {
                let emptyTable = Table(rows: [])
                tableView.reload(table: emptyTable)
            }
        }
    }

    lazy var tableView = TableOfElementsView()

    func setupTable() {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.al_edges(toView: view)
        setupTable()
    }
}
