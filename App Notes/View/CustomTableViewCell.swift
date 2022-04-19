//
//  CustomTableViewCell.swift
//  App Notes
//
//  Created by Sergey on 19.04.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

     var headerTextLabel = UILabel()
     var bodyTextLabel = UILabel()
     var dateTextLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        contentView.addSubview(headerTextLabel)
        headerTextLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        headerTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        headerTextLabel.translatesAutoresizingMaskIntoConstraints = false
    }

}
