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

    func getTable1() -> Table {
        var rows: [Row] = (0...20).map { i in
            var r = Row(ElementOf<TestNibView>(props: "Ind \(i)"))
            r.separatorStyle = .insets(left: 20, right: 8)
            r.backgroundColor = .blue
            return r
        }
        let sel: (Int) -> Row = { i in
            var vstack = Stack([ElementOf<TestNibView>(props: "\(i) V up"), ElementOf<TestNibView>(props: "\(i) V down")])
            vstack.layout.axis = .vertical
            let vertical = Component(props: vstack)
            let stack = Stack([ElementOf<TestNibView>(props: "\(i) s left"),
                               vertical])
            let sel = Row(Component(props: stack))
            return sel
        }
        rows = [sel(1222)] + rows + (0...4).map { i in sel(i) } + rows + (0...4).map { i in sel(100+i) }
        let s = { (num: Int) -> Section in Section(rows: rows, footer: SectionFooter(ElementOf<TestNibView>(props: "\(num) Footer!"))) }
        var table = Table(sections: [s(1), s(2)])
        table.guessesSameHeightsForCellsWithSameType = true
        return table
    }

    func getTable2() -> Table {
        let lb = ElementOfLabel("First Label that should automatically support AutoLayout! Yes this is so cool.")
        let im = ElementOfImageView(#imageLiteral(resourceName: "img1.png"))

        let section = Section(rows: [Row(lb), Row(im)], header: nil, footer: nil)
        let table = Table(sections: [section])
        return table
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let table = getTable2()
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
        return .frame(.zero)
    }
}
