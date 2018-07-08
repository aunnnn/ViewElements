//
//  ViewController.swift
//  ViewElementsExamples
//
//  Created by Wirawit Rueopas on 5/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit
import ViewElementsCore

extension Table {
    init(rowsBlock: () -> [Row]) {
        self.init(rows: rowsBlock())
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var rows: [Row] = (0...20).map { i in
            var r = Row(ElementOf<TestNibView>(props: "Ind \(i)"))
            r.separatorStyle = .insets(left: 20, right: 8)
            r.backgroundColor = .blue
            return r
        }
        let sel: (Int) -> Row = { i in
            let stack = Stack([ElementOf<TestNibView>(props: "\(i) s left").any,
                               ElementOf<TestNibView>(props: "\(i) s right").any])
            let sel = Row(Component(props: stack))
            return sel
        }
        rows = [sel(1222)] + rows + (0...4).map { i in sel(i) } + rows + (0...4).map { i in sel(100+i) }
        let s = Section(rows: rows, footer: SectionFooter(ElementOf<TestNibView>(props: "1st Footer!")))
        var table = Table(sections: [s, s])
        table.guessesSameHeightsForCellsWithSameType = true
        let tableView = TableOfElementsView()
        view.addSubview(tableView)
        tableView.al_edges(toView: view)
        tableView.reload(table: table)
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
