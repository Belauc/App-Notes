//
//  UISettings.swift
//  App Notes
//
//  Created by Sergey on 03.04.2022.
//

import UIKit

class UISettings {
    static let shared = UISettings()
    let marginTop: CGFloat = 35
    let marginLeft: CGFloat = 20
    let marginRight: CGFloat = -20
    let paddingTop: CGFloat = 10
    // let paddingLeft: CGFloat = 20
    // let paddingRight: CGFloat = -20
    let titleFontSize: CGFloat = 22
    let bodyFontSize: CGFloat = 14
    let placeholdeerForTitleNote = "Заголовок"
    var locale: Locale {
        let localeId = Locale.preferredLanguages.first
        return Locale(identifier: localeId!)
    }
}
//
// class AllStrings {
//    static let shared = AllStrings()
//    let placeholdeerForTitleNote = "Заголовок"
// }
