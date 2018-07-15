//
//  RemoteImageView.swift
//  SocialNetworkClone
//
//  Created by Wirawit Rueopas on 14/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit
import ViewElementsCore
import Kingfisher

func randomAlphaNumericString(length: Int) -> String {
    let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let allowedCharsCount = UInt32(allowedChars.count)
    var randomString = ""

    for _ in 0..<length {
        let randomNum = Int(arc4random_uniform(allowedCharsCount))
        let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
        let newCharacter = allowedChars[randomIndex]
        randomString += String(newCharacter)
    }

    return randomString
}

class RemoteImageView: UIImageView, ElementableView {
    typealias PropsType = URL
    func setup() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        kf.indicatorType = .activity
    }
    func render(props: URL) {
        kf.setImage(with: props)
    }
    static func buildMethod() -> ViewBuildMethod {
        return .frame(.zero)
    }
}
