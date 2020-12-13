//
//  SoundListController.swift
//  Alarmv
//
//  Created by vlsuv on 13.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

class SoundListController: UIViewController {
    // MARK: - Properties
    private let tableView: UITableView = UITableView()
    private let sounds: [String] = ["Sound One", "Sound Two"]
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        
        configureTableView()
        configureNavigationController()
    }
    
    deinit {
        print("deinit: soundlistcontroller")
    }
    
    // MARK: - Handlers
    private func configureNavigationController() {
        navigationItem.title = "Sounds"
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SoundListCell.self, forCellReuseIdentifier: SoundListCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        
        tableView.rowHeight = 44
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
}

// MARK: - UITableViewDataSource
extension SoundListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SoundListCell.identifier, for: indexPath) as? SoundListCell else {return UITableViewCell()}
        let sound = sounds[indexPath.row]
        cell.soundNameLabel.text = sound
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SoundListController: UITableViewDelegate {
    
}
