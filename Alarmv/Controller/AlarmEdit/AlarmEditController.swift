//
//  AlarmEditController.swift
//  Alarmv
//
//  Created by vlsuv on 28.11.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit
import CoreData

protocol AlarmEditControllerDelegate {
    func didTapSaveButton()
}

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
    
    private let notificationManager = NotificationManager()
    private let dataManager = DataManager()
    
    let delegate: AlarmEditControllerDelegate
    let alarm: Alarm
    
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
    
    init(with alarm: Alarm?, delegate: AlarmEditControllerDelegate) {
        self.alarm = alarm == nil ? Alarm(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) : alarm!
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        tableView.register(AlarmEditCell.self, forCellReuseIdentifier: AlarmEditCell.identifier)
        tableView.register(TimeCell.self, forCellReuseIdentifier: TimeCell.identifier)
        tableView.register(DateCell.self, forCellReuseIdentifier: DateCell.identifier)
        tableView.register(FieldCell.self, forCellReuseIdentifier: FieldCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        
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
        guard let alarmEditSection = AlarmEditSection(rawValue: indexPath.row) else {return UITableViewCell()}
        
        switch alarmEditSection {
        case .alarmTime:
            guard let timeCell = tableView.dequeueReusableCell(withIdentifier: TimeCell.identifier, for: indexPath) as? TimeCell else {return UITableViewCell()}
            timeCell.delegate = self
            timeCell.datePicker.date = alarm.time
            return timeCell
        case .alarmDate:
            guard let dateCell = tableView.dequeueReusableCell(withIdentifier: DateCell.identifier, for: indexPath) as? DateCell else {return UITableViewCell()}
            dateCell.delegate = self
            dateCell.updateButtonSelectionState(withRepeatDays: alarm.repeatDays)
            return dateCell
        case .repeatDate:
            guard let alarmEditCell = tableView.dequeueReusableCell(withIdentifier: AlarmEditCell.identifier, for: indexPath) as? AlarmEditCell else {return UITableViewCell()}
            alarmEditCell.settingNameLabel.text = alarmEditSection.description
            alarmEditCell.detailSettingTextLabel.text = alarm.nameOfRepeatDays()
            return alarmEditCell
        case .alarmName:
            guard let fieldCell = tableView.dequeueReusableCell(withIdentifier: FieldCell.identifier, for: indexPath) as? FieldCell else {return UITableViewCell()}
            fieldCell.settingTextField.delegate = self
            fieldCell.settingNameLabel.text = alarmEditSection.description
            fieldCell.settingTextField.text = alarm.name
            return fieldCell
        case .alarmSound:
            guard let alarmEditCell = tableView.dequeueReusableCell(withIdentifier: AlarmEditCell.identifier, for: indexPath) as? AlarmEditCell else {return UITableViewCell()}
            alarmEditCell.settingNameLabel.text = alarmEditSection.description
            alarmEditCell.detailSettingTextLabel.text = alarm.sound.name
            return alarmEditCell
        case .alarmSnooze:
            guard let alarmEditCell = tableView.dequeueReusableCell(withIdentifier: AlarmEditCell.identifier, for: indexPath) as? AlarmEditCell else {return UITableViewCell()}
            alarmEditCell.settingNameLabel.text = alarmEditSection.description
            alarmEditCell.detailSettingTextLabel.isHidden = true
            alarmEditCell.accessoryView = snoozeSwitchControl
            return alarmEditCell
        }
    }
}

// MARK: - UITableViewDelegate
extension AlarmEditController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let alarmEditSection = AlarmEditSection(rawValue: indexPath.row) else {return}
        switch alarmEditSection {
        case .alarmSound:
            let soundListController = SoundListController()
            soundListController.delegate = self
            navigationController?.pushViewController(soundListController, animated: true)
        default:
            return
        }
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
        
        notificationManager.setNotificationWithDate(id: alarm.uuid.uuidString, title: alarm.name, date: date, snooze: alarm.snoozeEnabled, sound: alarm.sound) { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self?.dataManager.save()
            self?.delegate.didTapSaveButton()
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
    func didSelectedRepeatDay(_ day: RepeatDay) {
        if let index = alarm.repeatDays.firstIndex(where: { $0.id == day.id }) {
            alarm.repeatDays.remove(at: index)
        } else {
            alarm.repeatDays.append(day)
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

// MARK: - SoundListControllerDelegate
extension AlarmEditController: SoundListControllerDelegate {
    func didSelectedSound(_ sound: Sound) {
        alarm.sound = sound
        tableView.reloadData()
    }
}
