//
//  AlarmListCell.swift
//  Alarmv
//
//  Created by vlsuv on 28.11.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

class AlarmListCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "alarmListCell"
    static let cellHeight: CGFloat = 80
    
    let alarmNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.black
        label.font = .systemFont(ofSize: 36, weight: .thin)
        return label
    }()
    
    let alarmDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.mediumGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    let alarmSwitchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = Colors.blue
        return switchControl
    }()
    
    func configureAlarm() {
        alarmNameLabel.text = "03:30 AM"
        alarmDateLabel.text = "Mon Tue Wen"
        alarmSwitchControl.isOn = true
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAlarmLabels()
        setupAlarmSwitchControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    private func setupAlarmLabels() {
        let stackView = UIStackView(arrangedSubviews: [alarmNameLabel, alarmDateLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        
        addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.anchor(left: leftAnchor, paddingLeft: 18)
    }
    
    private func setupAlarmSwitchControl() {
        addSubview(alarmSwitchControl)
        alarmSwitchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        alarmSwitchControl.anchor(right: rightAnchor, paddingRight: 18)
    }
}
