//
//  ListViewController.swift
//  App Notes
//
//  Created by Sergey on 10.04.2022.
//

import UIKit

final class ListViewController: UIViewController {

    var stackView = UIStackView()
    private enum UiSettings {
        static let marginTop: CGFloat = 35
        static let marginLeft: CGFloat = 20
        static let marginRight: CGFloat = -20
        static let paddingTop: CGFloat = 10
        static let titleFontSize: CGFloat = 22
        static let bodyFontSize: CGFloat = 14
        static let stackViewSpacing: CGFloat = 4
        static let titleForNavBar = "Заметки"
        static var dateFormater: DateFormatter {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "Дата: dd MMMM yyyy"
            dateFormater.locale = locale
            return dateFormater
        }
        static var placeholdeerForDatePicker: String {
            let now = Date()
            let date = dateFormater.string(from: now)
            return date
        }
        static var locale: Locale = Locale(identifier: "ru_RU")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Настройка Views
    private func configure() {
        setupViews()
    }

    private func setupViews() {
        setupUIStack()
        setupUIBase()
    }

    // MARK: - Настройка констрейтов и тд. для HeaderTeftField
    private func setupUIStack() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = UiSettings.stackViewSpacing
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                  constant: UiSettings.marginTop).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                   constant: UiSettings.marginLeft).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                    constant: UiSettings.marginRight).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let note = NoteCardView()
        stackView.addArrangedSubview(note)
    }

    // MARK: - Настройка общих views
    func setupUIBase() {
        view.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 254/255, alpha: 1)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = UiSettings.titleForNavBar
    }
}
