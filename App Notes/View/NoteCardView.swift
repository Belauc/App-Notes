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
    private let imageIcon = UIImageView()
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
        static let imageIconSize: CGFloat = 24
        static let fontForBodyAndDate = UIFont.systemFont(ofSize: 10, weight: .regular)
        static let colorForBody = UIColor(red: 172/255, green: 172/255, blue: 172/255, alpha: 1)
        static let backgroundColor = UIColor.systemBackground
        static let backgroundColorBase = UIColor(red: 249/255, green: 250/255, blue: 254/255, alpha: 1)
        static let locale = Locale(identifier: "ru_RU")
    }
    static let identificator = "noteCell"
    weak var model: Note? {
        willSet {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd.MM.yyyy"
            dateFormater.locale = UiSettings.locale
            dateTextLabel.text =  dateFormater.string(from: newValue?.date ?? Date())
            headerTextLabel.text = newValue?.title
            bodyTextLabel.text = newValue?.body
            imageIcon.image = UIImage(data: newValue?.cachedImage ?? Data())
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            selectedBackgroundView?.backgroundColor = UiSettings.backgroundColorBase
        }
    }

    private func setupSubView() {
        setupBackView()
        setupHeader()
        setupBody()
        setupImageIcon()
        setupDate()
    }

    private func setupBackView() {
        contentView.addSubview(backView)
        backView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        backView.leftAnchor.constraint(
            equalTo: leftAnchor
        ).isActive = true
        backView.rightAnchor.constraint(
            equalTo: contentView.rightAnchor
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
            equalTo: contentView.leftAnchor,
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
            equalTo: contentView.leftAnchor,
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

    private func setupImageIcon() {
        backView.addSubview(imageIcon)
        imageIcon.topAnchor.constraint(
            equalTo: bodyTextLabel.bottomAnchor,
            constant: UiSettings.marginHeaderToTop
        ).isActive = true
        imageIcon.rightAnchor.constraint(
            equalTo: backView.rightAnchor,
            constant: UiSettings.marginRight
        ).isActive = true
        imageIcon.bottomAnchor.constraint(
            equalTo: backView.bottomAnchor,
            constant: UiSettings.marginBottom
        ).isActive = true
        imageIcon.widthAnchor.constraint(equalToConstant: UiSettings.imageIconSize).isActive = true
        imageIcon.heightAnchor.constraint(equalToConstant: UiSettings.imageIconSize).isActive = true
        imageIcon.layer.cornerRadius = imageIcon.frame.height/2
        imageIcon.clipsToBounds = true
        imageIcon.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupDate() {
        backView.addSubview(dateTextLabel)
        dateTextLabel.topAnchor.constraint(
            equalTo: bodyTextLabel.bottomAnchor,
            constant: UiSettings.marginDateToBody
        ).isActive = true
        dateTextLabel.leftAnchor.constraint(
            equalTo: contentView.leftAnchor,
            constant: UiSettings.marginLeft
        ).isActive = true
        dateTextLabel.bottomAnchor.constraint(
            equalTo: backView.bottomAnchor,
            constant: UiSettings.marginBottom
        ).isActive = true
        dateTextLabel.font = UiSettings.fontForBodyAndDate
        dateTextLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
