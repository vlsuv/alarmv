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
    private let tableView: UITableView = UITableView()
    var emptyAlarmListImageView: UIImageView!
    
    private let notificationManager = NotificationManager()
    private let dataManager = DataManager()
    
    private var alarms: [Alarm] = [Alarm]()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationController()
        setupEmptyAlarmListImageView()
        configureTableView()
        fetchAlarms()
    }
    
    // MARK: - Requests
    private func fetchAlarms() {
        dataManager.fetch { [weak self] alarms in
            self?.alarms = alarms
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    @objc private func showAlarmEditPage() {
        let alarmEditController = AlarmEditController()
        alarmEditController.completion = { [weak self] in
            DispatchQueue.main.async {
                self?.fetchAlarms()
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        navigationController?.pushViewController(alarmEditController, animated: true)
    }
    
    // MARK: - Handlers
    private func configureNavigationController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(showAlarmEditPage))
        
        navigationController?.navigationBar.tintColor = Colors.blue
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Alarms"
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(AlarmListCell.self, forCellReuseIdentifier: AlarmListCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        
        tableView.rowHeight = Sizes.alarmCellHeight
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
    }
    
    private func setupEmptyAlarmListImageView() {
        emptyAlarmListImageView = UIImageView()
        emptyAlarmListImageView.image = Images.emptyAlarmList
        emptyAlarmListImageView.contentMode = .center
        
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
        let alarm = alarms[indexPath.row]
        cell.configure(with: alarm)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AlarmListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let alarm = alarms[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { [weak self] action, uiview, completion in
            self?.notificationManager.deleteNotification(alarm.uuid.uuidString)
            self?.dataManager.delete(alarm)
            self?.dataManager.save()
            self?.fetchAlarms()
        }
        deleteAction.image = Images.trash
        deleteAction.backgroundColor = Colors.red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
