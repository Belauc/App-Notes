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
    let titleForDoneButton = "Готово"
    let titleAlertForCheckNil = "Внимание"
    let messageAlertForCheckNil = "Необхоидмо заполнить хотя бы одно поле для сохранения"
    var dateFormater: DateFormatter {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "Дата: dd MMMM yyyy"
        dateFormater.locale = locale
        return dateFormater
    }
    var placeholdeerForDatePicker: String {
        let now = Date()
        let date = dateFormater.string(from: now)
        return date
    }
    var locale: Locale {
        let localeId = Locale.preferredLanguages.first
        return Locale(identifier: localeId!)
    }
}
