//
//  UISettings.swift
//  App Notes
//
//  Created by Sergey on 03.04.2022.
//

import UIKit

class ProjectSettings {
    static let shared = ProjectSettings()
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
    let dateFormat = "Дата: dd MMMM yyyy"
}
