//
//  AlarmEditTableFooterView.swift
//  Alarmv
//
//  Created by vlsuv on 02.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

protocol AlarmEditTableFooterViewDelegate: class {
    func didTapCancelButton()
    func didTapSaveButton()
}

class AlarmEditTableFooterView: UIView {
    // MARK: - Properties
    weak var delegate: AlarmEditTableFooterViewDelegate!
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        let normalAttributedString = NSAttributedString(string: "Cancel", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium),
            NSAttributedString.Key.foregroundColor: Color.white
        ])
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.backgroundColor = Color.blue
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        let normalAttributedString = NSAttributedString(string: "Save", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium),
            NSAttributedString.Key.foregroundColor: Color.white
        ])
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.backgroundColor = Color.blue
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func handleCancel() {
        delegate.didTapCancelButton()
    }
    
    @objc private func handleSave() {
        delegate.didTapSaveButton()
    }
    
    // MARK: - Handlers
    private func setupButtons() {
        addSubview(cancelButton)
        cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cancelButton.anchor(left: leftAnchor, paddingLeft: Spaces.baseHorizontalSpace, height: Sizes.buttonHeight, width: Sizes.buttonWidth)
        cancelButton.layer.cornerRadius = Sizes.cornerRadius
        
        addSubview(saveButton)
        saveButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        saveButton.anchor(right: rightAnchor, paddingRight: Spaces.baseHorizontalSpace, height: Sizes.buttonHeight, width: Sizes.buttonWidth)
        saveButton.layer.cornerRadius = Sizes.cornerRadius
    }
}
