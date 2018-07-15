//
//  Misc.swift
//  SocialNetworkClone
//
//  Created by Wirawit Rueopas on 14/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import SwiftDate

func randomLetter() -> String {
    let alphabets: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    return alphabets[Int(arc4random_uniform(26))]
}

func randomDate(daysBack: Int) -> Date {
    let day = arc4random_uniform(UInt32(daysBack))+1
    let hour = arc4random_uniform(23)
    let minute = arc4random_uniform(59)

    let today = Date(timeIntervalSinceNow: 0)
    let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    var offsetComponents = DateComponents()
    offsetComponents.day = -Int(day - 1)
    offsetComponents.hour = Int(hour)
    offsetComponents.minute = Int(minute)

    let randomDate = gregorian.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
    return randomDate!
}

extension Date {
    func relative() -> String {
        return toRelative(style: RelativeFormatter.twitterStyle(), locale: Locales.english)
    }
}
