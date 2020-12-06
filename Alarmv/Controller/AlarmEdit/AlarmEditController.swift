//
//  AlarmEditController.swift
//  Alarmv
//
//  Created by vlsuv on 28.11.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

class AlarmEditController: UIViewController {
    // MARK: - Properties
    private let tableView: UITableView = UITableView()
    private let alarmEditTableFooterView = AlarmEditTableFooterView()
    
    private let snoozeSwitchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = Colors.blue
        switchControl.addTarget(self, action: #selector(handleSnooze), for: .valueChanged)
        return switchControl
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        
        configureTableView()
        configureNavigationController()
    }
    
    deinit {
        print("deinit: alarmeditcontroller")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignFirstResponder()
    }
    
    // MARK: - Actions
    @objc private func handleSnooze() {
        print("handle snooze")
    }
    
    // MARK: - Handlers
    private func configureNavigationController() {
        navigationController?.navigationBar.tintColor = Colors.blue
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Edit Alarm"
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(BaseSettingCell.self, forCellReuseIdentifier: BaseSettingCell.identifier)
        tableView.register(TimeCell.self, forCellReuseIdentifier: TimeCell.identifier)
        tableView.register(DateCell.self, forCellReuseIdentifier: DateCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        
        tableView.allowsSelection = false
        tableView.rowHeight = Sizes.settingCellHeight
        tableView.isScrollEnabled = false
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        
        tableView.tableFooterView = alarmEditTableFooterView
        alarmEditTableFooterView.delegate = self
        tableView.tableFooterView?.frame.size.height = Sizes.buttonHeight
    }
}

// MARK: - UITableViewDataSource
extension AlarmEditController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmEditSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        guard let alarmEditSection = AlarmEditSection(rawValue: indexPath.row) else {return UITableViewCell()}
        switch alarmEditSection {
        case .alarmTime:
            guard let timeCell = tableView.dequeueReusableCell(withIdentifier: TimeCell.identifier, for: indexPath) as? TimeCell else {return UITableViewCell()}
            timeCell.delegate = self
            cell = timeCell
        case .alarmDate:
            cell = tableView.dequeueReusableCell(withIdentifier: DateCell.identifier, for: indexPath)
        case .repeatDate:
            guard let baseSettingCell = tableView.dequeueReusableCell(withIdentifier: BaseSettingCell.identifier, for: indexPath) as? BaseSettingCell else {return UITableViewCell()}
            baseSettingCell.sectionType = alarmEditSection
            
            baseSettingCell.settingNameLabel.text = alarmEditSection.description
            baseSettingCell.detailSettingTextLabel.text = alarmEditSection.description
            
            cell = baseSettingCell
        case .alarmLabel:
            guard let baseSettingCell = tableView.dequeueReusableCell(withIdentifier: BaseSettingCell.identifier, for: indexPath) as? BaseSettingCell else {return UITableViewCell()}
            baseSettingCell.sectionType = alarmEditSection
            baseSettingCell.settingTextField.delegate = self
            
            baseSettingCell.settingNameLabel.text = alarmEditSection.description
            
            cell = baseSettingCell
        case .alarmSound:
            guard let baseSettingCell = tableView.dequeueReusableCell(withIdentifier: BaseSettingCell.identifier, for: indexPath) as? BaseSettingCell else {return UITableViewCell()}
            baseSettingCell.sectionType = alarmEditSection
            
            baseSettingCell.settingNameLabel.text = alarmEditSection.description
            baseSettingCell.detailSettingTextLabel.text = alarmEditSection.description
            
            cell = baseSettingCell
        case .alarmSnooze:
            guard let baseSettingCell = tableView.dequeueReusableCell(withIdentifier: BaseSettingCell.identifier, for: indexPath) as? BaseSettingCell else {return UITableViewCell()}
            baseSettingCell.sectionType = alarmEditSection
            
            baseSettingCell.settingNameLabel.text = alarmEditSection.description
            baseSettingCell.accessoryView = snoozeSwitchControl
            
            cell = baseSettingCell
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AlarmEditController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let alarmEditSection = AlarmEditSection(rawValue: indexPath.row) else {return tableView.rowHeight}
        switch alarmEditSection {
        case .alarmTime:
            return 215
        default:
            return tableView.rowHeight
        }
    }
}

// MARK: - AlarmEditTableFooterViewDelegate
extension AlarmEditController: AlarmEditTableFooterViewDelegate {
    func didTapCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapSaveButton() {
        print("handle save")
    }
}

// MARK: - TimeCellDelegate
extension AlarmEditController: TimeCellDelegate {
    func didChangeDatePickerValue(atTime time: Date) {
        print("time: \(time)")
    }
}

// MARK: - UITextFieldDelegate
extension AlarmEditController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
