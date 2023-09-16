//
//  CompletionHeaderView.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/22.
//

import UIKit

class CompletionHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Subviews
    
    let calendarImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgCalendar
        }
    
    let label = UILabel()
        .then {
            $0.font = .pretendard(.semibold, ofSize: 14)
        }

    // MARK: - Life Cycles
    override func layoutSubviews() {
        super.layoutSubviews()
        
        render()
        configUI()
    }
    
    // MARK: - Functions
    
    func render() {
        self.addSubViews([calendarImageView, label])
        
        calendarImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.snp.leading).offset(24)
            make.width.height.equalTo(28)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(calendarImageView.snp.trailing).offset(8)
        }
    }

    func configUI() {
        self.backgroundView?.backgroundColor = .white
        self.backgroundView?.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
}
