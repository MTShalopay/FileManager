//
//  SettingCell.swift
//  FileManager
//
//  Created by Shalopay on 22.11.2022.
//

import UIKit

class SettingCell: UITableViewCell {
    static let indentificator = "SettingCell"
    private let userDefaults = UserDefaults.standard
    internal lazy var mySwitch: UISwitch = {
        let mySwitch = UISwitch()
        //mySwitch.addTarget(self, action: #selector(tapDidChange), for: .valueChanged)
        mySwitch.isOn = false
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        return mySwitch
    }()
    internal lazy var myLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(mySwitch)
        contentView.addSubview(myLabel)
        NSLayoutConstraint.activate([
            mySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            myLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            myLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            myLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }

}
