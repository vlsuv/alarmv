//
//  SettingsController.swift
//  Alarmv
//
//  Created by vlsuv on 21.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    // MARK: - Properties
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = AssetsColor.background
        return tableView
    }()
    
    private var models: [SettingsSection] = [SettingsSection]()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AssetsColor.background
        
        configureModels()
        configureTableView()
        configureNavigationController()
    }
    
    // MARK: - Handlers
    private func configureNavigationController() {
        navigationItem.title = "Settings"
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.register(SwitchCell.self, forCellReuseIdentifier: SwitchCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
    }
    
    private func configureModels() {
        models = [
            SettingsSection(title: "Appearance",
                            options: [
                                .switchCell(model: SettingsSwitchOption(title: "Dark Mode", icon: nil, handler: {
                                    UserSettings.darkMode = !UserSettings.darkMode
                                    
                                    UIApplication.shared.windows.forEach { window in
                                        window.overrideUserInterfaceStyle = UserSettings.darkMode ? .dark : .light
                                    }
                                }, isOn: UserSettings.darkMode))
            ]),
            SettingsSection(title: "About",
                            options: [
                                .staticCell(model: SettingsOption(title: "About Alarmv", icon: nil, handler: {
                                    print("show about alarmv page")
                                }))
            ])
        ]
    }
}

// MARK: - UITableViewDataSource
extension SettingsController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .staticCell(model: let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
            cell.textLabel?.text = model.title
            cell.accessoryType = .disclosureIndicator
            return cell
        case .switchCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.identifier, for: indexPath) as? SwitchCell else {return UITableViewCell()}
            cell.delegate = self
            cell.configure(with: model)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let type = models[indexPath.section].options[indexPath.row]
        
        switch type.self {
        case .staticCell(model: let model):
            model.handler()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Sizes.settingCellHeight
    }
}

// MARK: - SwitchCellDelegate
extension SettingsController: SwitchCellDelegate {
    func didChangeSwitchValue(with cell: SwitchCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let type = models[indexPath.section].options[indexPath.row]
        
        switch type.self {
        case .switchCell(model: let model):
            model.handler()
        default:
            return
        }
    }
}
