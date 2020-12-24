//
//  SwitchCell.swift
//  Alarmv
//
//  Created by vlsuv on 23.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate: class {
    func didChangeSwitchValue(with cell: SwitchCell)
}

class SwitchCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "SwitchCell"
    weak var delegate: SwitchCellDelegate!
    
    let settingSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = Colors.blue
        return switchControl
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSettingSwitch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func handleChangeSettingSwitchValue() {
        delegate.didChangeSwitchValue(with: self)
    }
    
    // MARK: - Handlers
    private func setupSettingSwitch() {
        self.accessoryView = settingSwitch
        settingSwitch.addTarget(self, action: #selector(handleChangeSettingSwitchValue), for: .valueChanged)
    }
    
    func configure(with model: SettingsSwitchOption) {
        textLabel?.text = model.title
        settingSwitch.isOn = model.isOn
    }
}
