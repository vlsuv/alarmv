//
//  SoundListController.swift
//  Alarmv
//
//  Created by vlsuv on 13.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

protocol SoundListControllerDelegate: class {
    func didSelectedSound(_ sound: Sound)
}

class SoundListController: UIViewController {
    // MARK: - Properties
    private let tableView: UITableView = UITableView()
    private let soundManager = SoundManager()
    weak var delegate: SoundListControllerDelegate!
    
    private let sounds: [Sound] = [
        Sound(name: "Early Riser", fileName: "EarlyRiser.mp3"),
        Sound(name: "Slow Morning", fileName: "SlowMorning.mp3")
    ]
    
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
    }
    
    private func getSoundIndexPath(_ sound: Sound) -> IndexPath? {
        guard let soundRow = sounds.firstIndex(of: sound) else {return nil}
        return IndexPath(row: soundRow, section: 0)
    }
    
    private func stopCurentlyPlaying() {
        if let currentSound = soundManager.curentlyPlaying() {
            soundManager.stop()
            if let stopIndex = getSoundIndexPath(currentSound), let cell = tableView.cellForRow(at: stopIndex) as? SoundListCell {
                cell.changePlayButtonStatus(play: false)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension SoundListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SoundListCell.identifier, for: indexPath) as? SoundListCell else {return UITableViewCell()}
        cell.delegate = self
        let sound = sounds[indexPath.row]
        cell.soundNameLabel.text = sound.name
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SoundListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedSound = sounds[indexPath.row]
        delegate.didSelectedSound(selectedSound)
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate
extension SoundListController: SoundListCellDelegate {
    func didTapPlayButton(with cell: SoundListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let sound = sounds[indexPath.row]
        
        guard sound != soundManager.curentlyPlaying() else {
            stopCurentlyPlaying()
            return
        }
        
        stopCurentlyPlaying()
        soundManager.play(this: sound)
        cell.changePlayButtonStatus(play: true)
    }
}
