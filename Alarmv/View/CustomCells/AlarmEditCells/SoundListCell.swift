//
//  SoundListCell.swift
//  Alarmv
//
//  Created by vlsuv on 13.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

protocol SoundListCellDelegate: class {
    func didTapPlayButton(with cell: SoundListCell)
}

class SoundListCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "SoundListCell"
    weak var delegate: SoundListCellDelegate!
    
    let soundNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = Color.text
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.play, for: .normal)
        button.setImage(Images.pause, for: .selected)
        button.addTarget(self, action: #selector(handlePlay(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        setupSoundNameLabel()
        setupPlayButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func handlePlay(_ sender: UIButton) {
        delegate.didTapPlayButton(with: self)
    }
    
    func changePlayButtonStatus(play: Bool) {
        playButton.isSelected = play
    }
    
    // MARK: - Handlers
    private func setupSoundNameLabel() {
        contentView.addSubview(soundNameLabel)
        soundNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        soundNameLabel.anchor(left: contentView.leftAnchor, paddingLeft: 18)
    }
    
    private func setupPlayButton() {
        contentView.addSubview(playButton)
        playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        playButton.anchor(right: contentView.rightAnchor, paddingRight: 18, height: 22, width: 22)
        playButton.addTarget(self, action: #selector(handlePlay(_:)), for: .touchUpInside)
    }
}
