//
//  SoundListCell.swift
//  Alarmv
//
//  Created by vlsuv on 13.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

class SoundListCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "SoundListCell"
    
    let soundNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = Colors.black
        return label
    }()
    
    let playSoundButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.play, for: .normal)
        button.setImage(Images.pause, for: .selected)
        button.addTarget(self, action: #selector(handlePlaySound(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSoundNameLabel()
        setupPlaySoundButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func handlePlaySound(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    // MARK: - Handlers
    private func setupSoundNameLabel() {
        contentView.addSubview(soundNameLabel)
        soundNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        soundNameLabel.anchor(left: contentView.leftAnchor, paddingLeft: 18)
    }
    
    private func setupPlaySoundButton() {
        contentView.addSubview(playSoundButton)
        playSoundButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        playSoundButton.anchor(right: contentView.rightAnchor, paddingRight: 18, height: 22, width: 22)
        playSoundButton.addTarget(self, action: #selector(handlePlaySound(_:)), for: .touchUpInside)
    }
}
