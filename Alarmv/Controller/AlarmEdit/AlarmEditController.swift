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
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let alarmEditTableFooterView: AlarmEditTableFooterView = {
        let view = AlarmEditTableFooterView()
        return view
    }()
    
    private let snoozeSwitchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = Color.blue
        switchControl.addTarget(self, action: #selector(handleSnooze(_:)), for: .valueChanged)
        return switchControl
    }()
    
    private var notificationManager: NotificationManagerType?
    
    private var dataManager: DataManagerType?
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let alarm: Alarm
    
    var completion: (() -> ())?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background
        
        snoozeSwitchControl.isOn = alarm.snoozeEnabled
        
        notificationManager = NotificationManager()
        dataManager = DataManager()
        
        configureTableView()
        configureNavigationController()
    }
    
    deinit {
        print("deinit: alarmeditcontroller")
    }
    
    init(with alarm: Alarm?) {
        self.alarm = alarm == nil ? Alarm(context: context) : alarm!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func handleSnooze(_ sender: UISwitch) {
        alarm.snoozeEnabled = sender.isOn
    }
    
    @objc private func handleCancel() {
        context.reset()
        completion?()
    }
    
    // MARK: - Handlers
    private func configureNavigationController() {
        navigationController?.navigationBar.tintColor = Color.blue
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
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
        tableView.backgroundColor = Color.background
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
        handleCancel()
    }
    
    func didTapSaveButton() {
        self.dataManager?.save()
        completion?()
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
