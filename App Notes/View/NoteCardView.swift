//
//  NoteCardView.swift
//  App Notes
//
//  Created by Sergey on 11.04.2022.
//

import UIKit

final class NoteCardView: UITableViewCell {

    private let headerTextLabel = UILabel()
    private let bodyTextLabel = UILabel()
    private let dateTextLabel = UILabel()
    let backView = UIView()
    private enum UiSettings {
        static let marginTop: CGFloat = 4
        static let marginHeaderToTop: CGFloat = 10
        static let marginLeft: CGFloat = 16
        static let marginRight: CGFloat = -16
        static let marginBottom: CGFloat = -10
        static let marginDateToBody: CGFloat = 24
        static let marginBodyToHeader: CGFloat = 4
        static let hightNoteView: CGFloat = 90
        static let titleFontSize: CGFloat = 16
        static let cornerRadius: CGFloat = 14
        static let fontForBodyAndDate = UIFont.systemFont(ofSize: 10, weight: .regular)
        static let colorForBody = UIColor(red: 172/255, green: 172/255, blue: 172/255, alpha: 1)
        static let backgroundColor = UIColor.systemBackground
        static let backgroundColorBase = UIColor(red: 249/255, green: 250/255, blue: 254/255, alpha: 1)
    }
    static let identificator = "noteCell"
    var model: Note? {
        willSet {
            dateTextLabel.text = newValue?.date
            headerTextLabel.text = newValue?.title
            bodyTextLabel.text = newValue?.body
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupNoteCardView()
        setupSubView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupNoteCardView() {
        self.backgroundColor = UiSettings.backgroundColorBase
    }

    private func setupSubView() {
        setupBackView()
        setupHeader()
        setupBody()
        setupDate()
    }

    private func setupBackView() {
        contentView.addSubview(backView)
        backView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        backView.leftAnchor.constraint(
            equalTo: leftAnchor,
            constant: UiSettings.marginLeft
        ).isActive = true
        backView.rightAnchor.constraint(
            equalTo: rightAnchor,
            constant: UiSettings.marginRight
        ).isActive = true
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.layer.cornerRadius = UiSettings.cornerRadius
        backView.backgroundColor = UiSettings.backgroundColor
        backView.heightAnchor.constraint(equalToConstant: UiSettings.hightNoteView).isActive = true
    }

    private func setupHeader() {
        backView.addSubview(headerTextLabel)
        headerTextLabel.topAnchor.constraint(
            equalTo: backView.topAnchor,
            constant: UiSettings.marginHeaderToTop
        ).isActive = true
        headerTextLabel.leftAnchor.constraint(
            equalTo: backView.leftAnchor,
            constant: UiSettings.marginLeft
        ).isActive = true
        headerTextLabel.rightAnchor.constraint(
            equalTo: backView.rightAnchor,
            constant: UiSettings.marginRight
        ).isActive = true
        headerTextLabel.font = UIFont.systemFont(ofSize: UiSettings.titleFontSize)
        headerTextLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupBody() {
        backView.addSubview(bodyTextLabel)
        bodyTextLabel.topAnchor.constraint(
            equalTo: headerTextLabel.bottomAnchor,
            constant: UiSettings.marginBodyToHeader
        ).isActive = true
        bodyTextLabel.leftAnchor.constraint(
            equalTo: backView.leftAnchor,
            constant: UiSettings.marginLeft
        ).isActive = true
        bodyTextLabel.rightAnchor.constraint(
            equalTo: backView.rightAnchor,
            constant: UiSettings.marginRight
        ).isActive = true
        bodyTextLabel.font = UiSettings.fontForBodyAndDate
        bodyTextLabel.textColor = UiSettings.colorForBody
        bodyTextLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupDate() {
        backView.addSubview(dateTextLabel)
        dateTextLabel.topAnchor.constraint(
            equalTo: bodyTextLabel.bottomAnchor,
            constant: UiSettings.marginDateToBody
        ).isActive = true
        dateTextLabel.leftAnchor.constraint(
            equalTo: backView.leftAnchor,
            constant: UiSettings.marginLeft
        ).isActive = true
        dateTextLabel.rightAnchor.constraint(
            equalTo: backView.rightAnchor,
            constant: UiSettings.marginRight
        ).isActive = true
        dateTextLabel.bottomAnchor.constraint(
            equalTo: backView.bottomAnchor,
            constant: UiSettings.marginBottom
        ).isActive = true
        dateTextLabel.font = UiSettings.fontForBodyAndDate
        dateTextLabel.translatesAutoresizingMaskIntoConstraints = false
    }

}
