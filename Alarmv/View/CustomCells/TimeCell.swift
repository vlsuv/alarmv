//
//  DateCell.swift
//  Alarmv
//
//  Created by vlsuv on 02.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

protocol TimeCellDelegate: class {
    func didChangeDatePickerValue(atTime time: Date)
}

class TimeCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "TimeCell"
    weak var delegate: TimeCellDelegate!
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        return picker
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDatePicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func handleDatePickerValueChanged() {	
        delegate?.didChangeDatePickerValue(atTime: datePicker.date)
    }
    
    // MARK: - Handlers
    private func setupDatePicker() {
        addSubview(datePicker)
        datePicker.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor)
        datePicker.addTarget(self, action: #selector(handleDatePickerValueChanged), for: .valueChanged)
    }
}
