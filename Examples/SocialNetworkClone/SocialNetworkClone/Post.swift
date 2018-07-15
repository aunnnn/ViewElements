//
//  Post.swift
//  SocialNetworkClone
//
//  Created by Wirawit Rueopas on 14/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ViewElementsCore

struct ProfileHeader {
    let first: String
    let last: String
    let subtitle: String
    let date: String

    func profileHeader() -> Component {
        let p = self
        let vstack = Stack(axis: .vertical, distribution: .fill, alignment: .leading, spacing: 4, elements: [
            ElementOfLabel("\(p.first) \(p.last)").customized(uniqueId: "profile header", { (lb) in
                lb.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            }),
            ElementOfLabel(p.subtitle).customized(uniqueId: "profile sub header", { (lb) in
                lb.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                lb.textColor = .gray
            })
            ])
        let vcomp = Component(props: vstack)
        let time = ElementOfLabel(p.date).customized(uniqueId: "profile time") { (lb) in
            lb.font = .systemFont(ofSize: 12, weight: .regular)
            lb.textColor = .gray
            lb.setContentHuggingPriority(.required, for: .horizontal)
        }

        let hstack = Stack(axis: .horizontal, distribution: .fill, alignment: .top, spacing: 8, elements: [
            ElementOf<RemoteImageView>(props: URL(string: "https://ui-avatars.com/api/?name=\(p.first.first!)+\(p.last.first!)")!).customized(uniqueId: "profile image", { (im) in
                im.heightAnchor.constraint(equalToConstant: 48).isActive = true
                im.widthAnchor.constraint(equalToConstant: 48).isActive = true
                im.contentMode = .scaleAspectFit
                im.layer.cornerRadius = 24
                im.layer.masksToBounds = true
            }),
            vcomp,
            time
            ])
        return Component(props: hstack)
    }

    func profileHeaderRow() -> Row {
        var row = Row(profileHeader())
        row.layoutMargins = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        return row
    }

}

struct Post {
    let profile: ProfileHeader
    let likesCount: Int

    func imageRow() -> Row {
        let rand = Int(arc4random_uniform(1000))
        var row = Row(ElementOf<RemoteImageView>(props: URL(string: "https://picsum.photos/200/300?image=\(rand)")!))
        row.rowHeight = 200
        return row
    }

    func likesRow(_ n: Int) -> (Variable<String>, Row) {
        let likes = Variable<String>("\(n) likes")
        let lb = ElementOf<RxLabel>(props: likes)
        var row = Row(lb.customized(uniqueId: "post like", { (lb) in
            lb.font = .systemFont(ofSize: 12, weight: .bold)
        }))
        row.rowHeight = 36
        row.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 0)
        return (likes, row)
    }

    //        func actionsPanelRow() -> Row {
    //
    //        }

    func likeButtonRow(didTap: @escaping () -> Void) -> Row {
        let el = ElementOfButton(Button.Props(
            id: randomAlphaNumericString(length: 10),
            image: nil,
            title: "Like",
            didTap: didTap)).customized(uniqueId: "like button", { (bttn) in
            bttn.setTitleColor(.blue, for: .normal)
            bttn.setTitleColor(UIColor.blue.withAlphaComponent(0.5), for: .highlighted)
        })
        return Row(el)
    }

    func postRows() -> [Row] {
        let (likes, lRow) = likesRow(likesCount)
        return [
            profile.profileHeaderRow(),
            imageRow(),
            lRow,
            likeButtonRow {
                likes.value += "-"
            },
            RowOfEmptyView(height: 20)
        ]
    }
}

extension Variable: Equatable where Element: Equatable {
    public static func ==(lhs: Variable, rhs: Variable) -> Bool {
        return lhs.value == rhs.value
    }
}

open class RxLabel: UILabel, ElementableView {
    public typealias PropsType = Variable<String>
    private var disposeBag: DisposeBag?

    open func setup() {
        numberOfLines = 0
    }

    public func render(props: PropsType) {
        let disposeBag = DisposeBag()
        props.asObservable().bind(to: self.rx.text).disposed(by: disposeBag)
        self.disposeBag = disposeBag
    }

    open class func buildMethod() -> ViewBuildMethod {
        return .frame(.zero)
    }
}
