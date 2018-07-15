//
//  ViewController.swift
//  SocialNetworkClone
//
//  Created by Wirawit Rueopas on 14/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit
import SwiftDate
import ViewElementsCore
import Bartinter

class HomeFeedViewController: TableOfElementsViewController {

    func manyPostRows(_ n: Int) -> [Row] {
        let rows = (0...10).map { (_) -> [Row] in
            let first = "\(randomLetter().uppercased())ohn"
            let last = "\(randomLetter().uppercased())oe"
            let p = ProfileHeader(first: first, last: last, subtitle: "Bangkok", date: DateInRegion.randomDate(withinDaysBeforeToday: 10).toRelative())
            let post = Post(profile: p, likesCount: Int(arc4random_uniform(1000)) + 200)
            return post.postRows()
        }
        return rows.flatMap { $0 }
    }

    func sectionHeader(title: String) -> SectionHeader {
        let el = ElementOfLabel(title).customized(uniqueId: "section header") { (lb) in
            lb.font = .systemFont(ofSize: 18, weight: .bold)
        }
        var h = SectionHeader(el)
        h.layoutMargins = .init(top: 8, left: 12, bottom: 8, right: 12)
        h.backgroundColor = .lightText
        return h
    }

    override func setupTable() {
        let today = Section(rows: manyPostRows(8), header: sectionHeader(title: "Today"))
        let yesterday = Section(rows: manyPostRows(4), header: sectionHeader(title: "Yesterday"))
        let prev = Section(rows: manyPostRows(10))
        let allSecs = [today, yesterday, prev]
        let table = Table(sections: allSecs)
        self.table = table

        updatesStatusBarAppearanceAutomatically = true
    }
}

