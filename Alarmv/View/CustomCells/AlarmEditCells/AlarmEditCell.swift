//
//  BaseSettingCell.swift
//  Alarmv
//
//  Created by vlsuv on 04.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

class AlarmEditCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "BaseSettingCell"
    
    let settingNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = Color.text
        return label
    }()
    
    let detailSettingTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = Color.mediumGray
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        setupLabels()
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
}
