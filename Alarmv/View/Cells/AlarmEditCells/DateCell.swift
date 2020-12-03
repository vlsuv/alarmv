//
//  DateCell.swift
//  Alarmv
//
//  Created by vlsuv on 02.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "DateCell"
    
    var dateButtons: [UIButton] = [UIButton]()
    let dates: [String] = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
    
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
        print("date: \(dates[index])")
        sender.isSelected.toggle()
        sender.backgroundColor = sender.isSelected ? Colors.blue : Colors.lightGray
    }
    
    // MARK: - Handlers
    private func addDateButtons() {
        for date in dates {
            let button = UIButton()
            
            let normalAttributedString = NSAttributedString(string: date, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                NSAttributedString.Key.foregroundColor: Colors.black
                ])
            let selectedAttributedString = NSAttributedString(string: date, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                NSAttributedString.Key.foregroundColor: Colors.white
            ])
            
            button.setAttributedTitle(normalAttributedString, for: .normal)
            button.setAttributedTitle(selectedAttributedString, for: .selected)
            button.backgroundColor = Colors.lightGray
            button.anchor(height: 38, width: 38)
            button.layer.cornerRadius = 38/2
            
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
