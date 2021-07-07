//
//  FieldCell.swift
//  Alarmv
//
//  Created by vlsuv on 11.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

class FieldCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "FieldCell"
    
    let settingNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = Color.text
        return label
    }()
    
    var settingTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.font = .systemFont(ofSize: 18, weight: .light)
        textField.textColor = Color.mediumGray
        return textField
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        setupSettingNameLabel()
        setupSettingTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    private func setupSettingNameLabel() {
        addSubview(settingNameLabel)
        settingNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        settingNameLabel.anchor(left: leftAnchor, paddingLeft: Spaces.baseHorizontalSpace)
    }
    
    private func setupSettingTextField() {
        addSubview(settingTextField)
        settingTextField.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, paddingRight: Spaces.baseHorizontalSpace, width: 200)
    }
}
