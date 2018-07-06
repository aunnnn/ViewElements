//
//  ViewController.swift
//  ViewElementsExamples
//
//  Created by Wirawit Rueopas on 5/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit
import ViewElements

extension Table {
    init(rowsBlock: () -> [Row]) {
        self.init(rows: rowsBlock())
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let table = Table { () -> [Row] in
            var r1 = Row(ElementOf<TestNibView>(props: "Wow hello"))
            r1.separatorStyle = .insets(left: 20, right: 8)
            r1.backgroundColor = .blue
            return [r1, r1]
        }
        let tableView = TableOfElementsView(table: table)
        view.addSubview(tableView)
        tableView.al_edges(toView: view)
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
}

class MyView: UIView, ElementableView {

    typealias PropsType = String

    func setup() {
        backgroundColor = .green
    }

    func render(props: String) {
        print(props)
    }

    class func buildMethod() -> ViewBuildMethod {
        return .init
    }
}
