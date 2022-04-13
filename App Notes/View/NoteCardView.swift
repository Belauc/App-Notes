//
//  NoteCardView.swift
//  App Notes
//
//  Created by Sergey on 11.04.2022.
//

import UIKit

final class NoteCardView: UIView {

    var headerTextLabel = UILabel()
    var bodyTextLabel = UILabel()
    var dateTextLabel = UILabel()
    private enum UiSettings {
        static let marginTop: CGFloat = 10
        static let marginLeft: CGFloat = 16
        static let marginRight: CGFloat = -16
        static let marginBottom: CGFloat = -10
        static let titleFontSize: CGFloat = 16
        static let bodyFontSize: CGFloat = 10
        static let cornerRadius: CGFloat = 14
        static let backgroundColor = UIColor.systemBackground
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNoteCardView()
        setupSubView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupNoteCardView() {
        layer.cornerRadius = UiSettings.cornerRadius
        self.backgroundColor = UiSettings.backgroundColor
    }

    private func setupSubView() {
        setupHeader()
        setupBody()
        setupDate()
    }

    private func setupHeader() {
        addSubview(headerTextLabel)
        headerTextLabel.topAnchor.constraint(equalTo: topAnchor,
                                             constant: UiSettings.marginTop).isActive = true
        headerTextLabel.leftAnchor.constraint(equalTo: leftAnchor,
                                              constant: UiSettings.marginLeft).isActive = true
        headerTextLabel.rightAnchor.constraint(equalTo: rightAnchor,
                                               constant: UiSettings.marginRight).isActive = true
        headerTextLabel.font = UIFont.systemFont(ofSize: UiSettings.titleFontSize)
        headerTextLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupBody() {
        addSubview(bodyTextLabel)
        bodyTextLabel.topAnchor.constraint(equalTo: headerTextLabel.bottomAnchor,
                                           constant: 4).isActive = true
        bodyTextLabel.leftAnchor.constraint(equalTo: leftAnchor,
                                            constant: UiSettings.marginLeft).isActive = true
        bodyTextLabel.rightAnchor.constraint(equalTo: rightAnchor,
                                             constant: UiSettings.marginRight).isActive = true
        bodyTextLabel.font = UIFont.systemFont(ofSize: UiSettings.bodyFontSize)
        bodyTextLabel.textColor = UIColor(red: 172/255, green: 172/255, blue: 172/255, alpha: 1)
        bodyTextLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupDate() {
        addSubview(dateTextLabel)
        dateTextLabel.topAnchor.constraint(equalTo: bodyTextLabel.bottomAnchor,
                                           constant: 24).isActive = true
        dateTextLabel.leftAnchor.constraint(equalTo: leftAnchor,
                                            constant: UiSettings.marginLeft).isActive = true
        dateTextLabel.rightAnchor.constraint(equalTo: rightAnchor,
                                             constant: UiSettings.marginRight).isActive = true
        dateTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: UiSettings.marginBottom).isActive = true
        dateTextLabel.font = UIFont.systemFont(ofSize: UiSettings.bodyFontSize)
        dateTextLabel.translatesAutoresizingMaskIntoConstraints = false
    }

}
