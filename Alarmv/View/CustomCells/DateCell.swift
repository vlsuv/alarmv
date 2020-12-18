//
//  DateCell.swift
//  Alarmv
//
//  Created by vlsuv on 02.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

protocol DateCellDelegate: class {
    func didSelectedRepeatDay(_ day: RepeatDay)
}

class DateCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "DateCell"
    weak var delegate: DateCellDelegate!
    
    var dateButtons: [UIButton] = [UIButton]()
    let repeatDays: [RepeatDay] = [
        RepeatDay(name: "Mo", id: 2),
        RepeatDay(name: "Tu", id: 3),
        RepeatDay(name: "We", id: 4),
        RepeatDay(name: "Th", id: 5),
        RepeatDay(name: "Fr", id: 6),
        RepeatDay(name: "Sa", id: 7),
        RepeatDay(name: "Su", id: 1)
    ]
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addDateButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func handleDate(_ sender: UIButton) {
        guard let index = dateButtons.firstIndex(of: sender) else {return}
        let repeatDay = repeatDays[index]
        
        delegate.didSelectedRepeatDay(repeatDay)
    }
    
    func updateButtonSelectionState(withRepeatDays repeatDays: [RepeatDay]) {
        for dateButton in dateButtons {
            if repeatDays.contains(where: { $0.id == dateButton.tag }) {
                dateButton.isSelected = true
                dateButton.backgroundColor = Colors.blue
            } else {
                dateButton.isSelected = false
                dateButton.backgroundColor = Colors.lightGray
            }
        }
    }
    
    // MARK: - Handlers
    private func addDateButtons() {
        for repeatDay in repeatDays {
            let button = UIButton()
            
            let normalAttributedString = NSAttributedString(string: repeatDay.name, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                NSAttributedString.Key.foregroundColor: Colors.black
                ])
            let selectedAttributedString = NSAttributedString(string: repeatDay.name, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                NSAttributedString.Key.foregroundColor: Colors.white
            ])
            
            button.setAttributedTitle(normalAttributedString, for: .normal)
            button.setAttributedTitle(selectedAttributedString, for: .selected)
            button.backgroundColor = Colors.lightGray
            button.anchor(height: 38, width: 38)
            button.layer.cornerRadius = 38/2
            
            button.tag = repeatDay.id
            
            button.addTarget(self, action: #selector(handleDate(_:)), for: .touchUpInside)
            
            dateButtons.append(button)
        }
        setupDateButton()
    }
    
    func setupDateButton() {
        let stackView = UIStackView(arrangedSubviews: dateButtons)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingLeft: Spaces.baseHorizontalSpace, paddingRight: Spaces.baseHorizontalSpace)
    }
}
