//
//  ViewController.swift
//  Alarmv
//
//  Created by vlsuv on 28.11.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

class AlarmListController: UIViewController {
    
    // MARK: - Properties
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = Sizes.alarmCellHeight
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Color.background
        return tableView
    }()
    
    var emptyAlarmListImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.emptyAlarmList
        imageView.contentMode = .center
        return imageView
    }()
    
    private var notificationManager: NotificationManagerType?
    
    private var dataManager: DataManagerType?
    
    private var alarms: [Alarm] = [Alarm]()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background
        
        notificationManager = NotificationManager()
        dataManager = DataManager()
        
        configureNavigationController()
        configureEmptyAlarmListImageView()
        configureTableView()
        getAlarms()
    }
    
    // MARK: - Fetch
    private func getAlarms() {
        dataManager?.fetch { [weak self] alarms in
            self?.alarms = alarms
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        notificationManager?.reShedule(self.alarms)
    }
    
    // MARK: - Actions
    @objc private func handleAdd() {
        let alarmEditController = AlarmEditController(with: nil)
        alarmEditController.completion = {
            DispatchQueue.main.async { [weak self] in
                self?.getAlarms()
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        navigationController?.pushViewController(alarmEditController, animated: true)
    }
    
    private func handleEdit(with alarm: Alarm) {
        let alarmEditController = AlarmEditController(with: alarm)
        alarmEditController.completion = {
            DispatchQueue.main.async { [weak self] in
                self?.getAlarms()
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        navigationController?.pushViewController(alarmEditController, animated: true)
    }
    
    @objc private func showSettings() {
        navigationController?.pushViewController(SettingsController(), animated: true)
    }
    
    // MARK: - Configures
    private func configureNavigationController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
        
        navigationController?.navigationBar.tintColor = Color.blue
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Alarms"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.text]
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(AlarmListCell.self, forCellReuseIdentifier: AlarmListCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
    }
    
    private func configureEmptyAlarmListImageView() {
        view.addSubview(emptyAlarmListImageView)
        emptyAlarmListImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
    }
    
    private func showEmptyAlarmListImageView(_ isShow: Bool) {
        tableView.isHidden = isShow
        emptyAlarmListImageView.isHidden = !isShow
    }
}

// MARK: - UITableViewDataSource
extension AlarmListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showEmptyAlarmListImageView(alarms.count == 0)
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmListCell.identifier, for: indexPath) as! AlarmListCell
        cell.delegate = self
        let alarm = alarms[indexPath.row]
        cell.configure(with: alarm)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AlarmListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedAlarm = alarms[indexPath.row]
        handleEdit(with: selectedAlarm)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let alarm = alarms[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { [weak self] action, uiview, completion in
            self?.notificationManager?.deleteNotification(withIdentifier: alarm.uuid)
            self?.dataManager?.delete(alarm)
            self?.dataManager?.save()
            self?.getAlarms()
        }
        deleteAction.image = Images.trash
        deleteAction.backgroundColor = Color.red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - AlarmListCellDelegate
extension AlarmListController: AlarmListCellDelegate {
    func didChangeSwitchControlValue(with cell: AlarmListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        
        let alarm = alarms[indexPath.row]
        alarm.enabled.toggle()
        
        dataManager?.save()
        notificationManager?.reShedule(self.alarms)
    }
}
