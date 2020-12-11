//
//  AlarmEditController.swift
//  Alarmv
//
//  Created by vlsuv on 28.11.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit
import CoreData

class AlarmEditController: UIViewController {
    // MARK: - Properties
    private let tableView: UITableView = UITableView()
    private let alarmEditTableFooterView = AlarmEditTableFooterView()
    private let snoozeSwitchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = Colors.blue
        switchControl.addTarget(self, action: #selector(handleSnooze(_:)), for: .valueChanged)
        return switchControl
    }()
    
    var completion: (() -> ())?
    
    private let notificationManager = NotificationManager()
    private let dataManager = DataManager()
    
    var alarm: Alarm = Alarm(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        snoozeSwitchControl.isOn = alarm.snoozeEnabled
        
        configureTableView()
        configureNavigationController()
    }
    
    deinit {
        print("deinit: alarmeditcontroller")
    }
    
    // MARK: - Actions
    @objc private func handleSnooze(_ sender: UISwitch) {
        alarm.snoozeEnabled = sender.isOn
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
            timeCell.datePicker.date = alarm.time
            
            cell = timeCell
        case .alarmDate:
            guard let dateCell = tableView.dequeueReusableCell(withIdentifier: DateCell.identifier, for: indexPath) as? DateCell else {return UITableViewCell()}
            dateCell.delegate = self
            
            cell = dateCell
        case .repeatDate:
            guard let baseSettingCell = tableView.dequeueReusableCell(withIdentifier: BaseSettingCell.identifier, for: indexPath) as? BaseSettingCell else {return UITableViewCell()}
            baseSettingCell.sectionType = alarmEditSection
            baseSettingCell.settingNameLabel.text = alarmEditSection.description
            baseSettingCell.detailSettingTextLabel.text = alarm.nameOfRepeatDays()
            
            cell = baseSettingCell
        case .alarmLabel:
            guard let baseSettingCell = tableView.dequeueReusableCell(withIdentifier: BaseSettingCell.identifier, for: indexPath) as? BaseSettingCell else {return UITableViewCell()}
            baseSettingCell.sectionType = alarmEditSection
            baseSettingCell.settingTextField.delegate = self
            baseSettingCell.settingNameLabel.text = alarmEditSection.description
            baseSettingCell.settingTextField.text = alarm.name
            
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
        let date = DateHelper.createDate(time: alarm.time)
        
        notificationManager.setNotificationWithDate(id: alarm.uuid.uuidString, title: alarm.name, date: date, snooze: alarm.snoozeEnabled) { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self?.dataManager.save()
            self?.completion?()
        }
    }
}

// MARK: - TimeCellDelegate
extension AlarmEditController: TimeCellDelegate {
    func didChangeDatePickerValue(atTime time: Date) {
        alarm.time = time
    }
}

// MARK: - DateCellDelegate
extension AlarmEditController: DateCellDelegate {
    func didSelectedRepeatDay(_ weekday: RepeatDay) {
        if alarm.repeatDays[weekday.id] != nil {
            alarm.repeatDays.removeObject(forKey: weekday.id)
        } else {
            alarm.repeatDays[weekday.id] = weekday.name
        }
        tableView.reloadData()
    }
}

// MARK: - UITextFieldDelegate
extension AlarmEditController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let name = textField.text {
            alarm.name = name
        }
        textField.resignFirstResponder()
        return false
    }
}
