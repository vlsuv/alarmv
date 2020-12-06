//
//  BaseSettingCell.swift
//  Alarmv
//
//  Created by vlsuv on 04.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

class BaseSettingCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "BaseSettingCell"
    
    let settingNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = Colors.black
        return label
    }()
    
    let detailSettingTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = Colors.mediumGray
        return label
    }()
    
    var settingTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "To type alarm name"
        textField.textAlignment = .right
        textField.font = .systemFont(ofSize: 18, weight: .light)
        textField.textColor = Colors.mediumGray
        return textField
    }()
    
    var sectionType: AlarmEditSectionType? {
        didSet {
            guard let sectionType = sectionType else {return}
            detailSettingTextLabel.isHidden = !sectionType.containsDetailSettingTextLabel
            settingTextField.isHidden = !sectionType.containsDetailSettingTextField
        }
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabels()
        setupSettingTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    private func setupLabels() {
        addSubview(settingNameLabel)
        settingNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        settingNameLabel.anchor(left: leftAnchor, paddingLeft: Spaces.baseHorizontalSpace)
        
        addSubview(detailSettingTextLabel)
        detailSettingTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        detailSettingTextLabel.anchor(right: rightAnchor, paddingRight: Spaces.baseHorizontalSpace)
    }
    
    private func setupSettingTextField() {
        addSubview(settingTextField)
        settingTextField.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, paddingRight: Spaces.baseHorizontalSpace, width: 200)
    }
}
