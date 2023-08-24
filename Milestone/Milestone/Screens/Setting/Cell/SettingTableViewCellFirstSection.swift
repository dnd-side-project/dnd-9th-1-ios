//
//  SettingTableViewCell.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/24.
//

import UIKit

class SettingTableViewCellFirstSection: BaseTableViewCell {
    
    // MARK: - Subviews
    
    let containerView = UIView()
    
    let label = UILabel()
        .then {
            $0.textColor = .black
            $0.font = .pretendard(.semibold, ofSize: 16)
        }
    
    let toggleButton = UISwitch()
        .then {
            $0.onTintColor = .primary
        }
    
    // MARK: - Properties
    
    static let identifier = "SettingTableViewCellFirstSection"
    
    // MARK: - Functions
    
    override func render() {
        self.contentView.addSubview(containerView)
        
        containerView.addSubViews([label, toggleButton])
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(4)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading).offset(24)
            make.centerY.equalTo(containerView)
        }
        
        toggleButton.snp.makeConstraints { make in
            make.trailing.equalTo(containerView.snp.trailing).offset(-24)
            make.centerY.equalTo(containerView.snp.centerY)
        }
    }
    
    override func configUI() {
        self.contentView.backgroundColor = .gray03
    }
}
