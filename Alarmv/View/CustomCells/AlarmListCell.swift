//
//  AlarmListCell.swift
//  Alarmv
//
//  Created by vlsuv on 28.11.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

protocol AlarmListCellDelegate: class {
    func didChangeSwitchControlValue(with cell: AlarmListCell)
}

class AlarmListCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "alarmListCell"
    weak var delegate: AlarmListCellDelegate!
    
    let alarmNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = AssetsColor.text
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
    
    func configure(with alarm: Alarm) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let time = dateFormatter.string(from: alarm.time)
        
        alarmNameLabel.text = time
        alarmDateLabel.text = alarm.nameOfRepeatDays()
        alarmSwitchControl.isOn = alarm.enabled
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        setupAlarmLabels()
        setupAlarmSwitchControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func handleChangeSwitchControlValue() {
        delegate.didChangeSwitchControlValue(with: self)
    }
    
    // MARK: - Handlers
    private func setupAlarmLabels() {
        let stackView = UIStackView(arrangedSubviews: [alarmNameLabel, alarmDateLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        
        addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.anchor(left: leftAnchor, paddingLeft: Spaces.baseHorizontalSpace)
    }
    
    private func setupAlarmSwitchControl() {
        addSubview(alarmSwitchControl)
        alarmSwitchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        alarmSwitchControl.anchor(right: rightAnchor, paddingRight: Spaces.baseHorizontalSpace)
        alarmSwitchControl.addTarget(self, action: #selector(handleChangeSwitchControlValue), for: .valueChanged)
    }
}
