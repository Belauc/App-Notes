//
//  NoteCardView.swift
//  App Notes
//
//  Created by Sergey on 11.04.2022.
//

import UIKit

final class NoteCardView: UITableViewCell {

    private var headerTextLabel = UILabel()
    private var bodyTextLabel = UILabel()
    private var dateTextLabel = UILabel()
    private enum UiSettings {
        static let marginTop: CGFloat = 10
        static let marginLeft: CGFloat = 16
        static let marginRight: CGFloat = -16
        static let marginBottom: CGFloat = -10
        static let marginDateToBody: CGFloat = 24
        static let marginBodyToHeader: CGFloat = 4
        static let titleFontSize: CGFloat = 16
        static let cornerRadius: CGFloat = 14
        static let fontForBodyAndDate = UIFont.systemFont(ofSize: 10, weight: .regular)
        static let colorForBody = UIColor(red: 172/255, green: 172/255, blue: 172/255, alpha: 1)
        static let backgroundColor = UIColor.systemBackground
    }
    static let identificator = "noteCell"
    var model: Note? {
        didSet {
            dateTextLabel.text = oldValue?.date
            headerTextLabel.text = oldValue?.title
            bodyTextLabel.text = oldValue?.body
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
        layer.cornerRadius = UiSettings.cornerRadius
        self.backgroundColor = UiSettings.backgroundColor
    }

    private func setupSubView() {
        setupHeader()
        setupBody()
        setupDate()
    }

    private func setupHeader() {
        contentView.addSubview(headerTextLabel)
        headerTextLabel.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: UiSettings.marginTop
        ).isActive = true
        headerTextLabel.leftAnchor.constraint(
            equalTo: leftAnchor,
            constant: UiSettings.marginLeft
        ).isActive = true
        headerTextLabel.rightAnchor.constraint(
            equalTo: rightAnchor,
            constant: UiSettings.marginRight
        ).isActive = true
        headerTextLabel.font = UIFont.systemFont(ofSize: UiSettings.titleFontSize)
        headerTextLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupBody() {
        contentView.addSubview(bodyTextLabel)
        bodyTextLabel.topAnchor.constraint(
            equalTo: headerTextLabel.bottomAnchor,
            constant: UiSettings.marginBodyToHeader
        ).isActive = true
        bodyTextLabel.leftAnchor.constraint(
            equalTo: contentView.leftAnchor,
            constant: UiSettings.marginLeft
        ).isActive = true
        bodyTextLabel.rightAnchor.constraint(
            equalTo: contentView.rightAnchor,
            constant: UiSettings.marginRight
        ).isActive = true
        bodyTextLabel.font = UiSettings.fontForBodyAndDate
        bodyTextLabel.textColor = UiSettings.colorForBody
        bodyTextLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupDate() {
        contentView.addSubview(dateTextLabel)
        dateTextLabel.topAnchor.constraint(
            equalTo: bodyTextLabel.bottomAnchor,
            constant: UiSettings.marginDateToBody
        ).isActive = true
        dateTextLabel.leftAnchor.constraint(
            equalTo: contentView.leftAnchor,
            constant: UiSettings.marginLeft
        ).isActive = true
        dateTextLabel.rightAnchor.constraint(
            equalTo: contentView.rightAnchor,
            constant: UiSettings.marginRight
        ).isActive = true
        dateTextLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: UiSettings.marginBottom
        ).isActive = true
        dateTextLabel.font = UiSettings.fontForBodyAndDate
        dateTextLabel.translatesAutoresizingMaskIntoConstraints = false
    }

}
