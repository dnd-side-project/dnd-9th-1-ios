//
//  SettingTableViewCellSecondSection.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/24.
//

import UIKit

class SettingTableViewCellSecondSection: BaseTableViewCell {
    
    // MARK: - Subviews
    
    let containerView = UIView()
        .then {
            $0.backgroundColor = .gray03
        }
    
    let label = UILabel()
        .then {
            $0.font = .pretendard(.semibold, ofSize: 16)
        }
    
    // MARK: - Properties
    
    static let identifier = "SettingTableViewCellSecondSection"
    
    // MARK: - Functions
    
    override func render() {
        self.contentView.addSubview(containerView)
        containerView.addSubview(label)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(4)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(containerView).offset(24)
            make.centerY.equalTo(containerView)
        }
    }
    
    override func configUI() {
        self.contentView.backgroundColor = .gray03
    }
}
