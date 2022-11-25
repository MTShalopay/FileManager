//
//  FileManagerCell.swift
//  FileManager
//
//  Created by Shalopay on 24.11.2022.
//

import UIKit

class FileManagerCell: UITableViewCell {
    static let indetificator = "FileManagerCell"
    internal lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    internal lazy var sizeLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    private func setupCell() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(sizeLabel)
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            sizeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sizeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
