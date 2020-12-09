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
    private var alarms: [Alarm] = [Alarm]()

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationController()
        configureTableView()
    }
    
    // MARK: - Actions
    @objc private func showAlarmEditPage() {
        navigationController?.pushViewController(AlarmEditController(), animated: true)
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
}

// MARK: - UITableViewDataSource
extension AlarmListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmListCell.identifier, for: indexPath) as! AlarmListCell
        cell.configureAlarm()
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AlarmListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
