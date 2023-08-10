//
//  ParentGoalTableViewCell.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/11.
//

import UIKit

import SnapKit
import Then

// MARK: - 상위 목표 테이블뷰 셀

class ParentGoalTableViewCell: BaseTableViewCell {
    
    static let identifier = "ParentGoalCell"
    
    // MARK: - Subviews
    
    let goalStatusImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgTempGoal
        }
    
    public var titleLabel = UILabel()
        .then {
            $0.text = "토익 900점 넘기기"
            $0.font = .pretendard(.semibold, ofSize: 18)
            $0.textColor = .black
            $0.textAlignment = .left
        }
    
    let calendarImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgCalendar
        }
    
    public var termLabel = UILabel()
        .then {
            $0.text = "2023.09.08 - 2023.12.02"
            $0.font = .pretendard(.regular, ofSize: 12)
            $0.textColor = .gray03
            $0.textAlignment = .left
        }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    // MARK: - Functions
    
    override func configUI() {
        self.backgroundColor = .gray01
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 20
    }
    
    override func render() {
        contentView.addSubViews([goalStatusImageView, titleLabel,
                                      calendarImageView, termLabel])
        
        goalStatusImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(goalStatusImageView.snp.right).offset(16)
            $0.top.equalTo(goalStatusImageView).offset(3)
            $0.right.equalToSuperview().inset(52)
        }
        
        calendarImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5.67)
            $0.left.equalTo(titleLabel)
            $0.width.height.equalTo(13)
        }
        
        termLabel.snp.makeConstraints {
            $0.left.equalTo(calendarImageView.snp.right).offset(8)
            $0.centerY.equalTo(calendarImageView)
        }
    }
}
