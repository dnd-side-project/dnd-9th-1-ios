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
    
    let containerView = UIView()
        .then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
        }
    
    // MARK: 데이터 바인딩 필요!
    /// 반드시 인스턴스 생성 시점에 초기화 진행해야됨.
    /// 나중에 바인딩하면 draw메서드가 다시 호출되지 않아 원을 그릴 수 없음
    lazy var goalAchievementRateView = GoalAchievementRateView()
        .then {
            $0.totalCount = 9
            $0.completedCount = 6
        }
    
    public var titleLabel = UILabel()
        .then {
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
            $0.font = .pretendard(.regular, ofSize: 12)
            $0.textColor = .gray03
            $0.textAlignment = .left
        }
    
    // MARK: - Functions
    
    override func configUI() {
        self.backgroundColor = .gray01
        self.selectionStyle = .none
        
        // 그림자 설정
        self.containerView.makeShadow(color: .init(hex: "#DCDCDC"), alpha: 1.0, x: 0, y: 0, blur: 7, spread: 0)
    }
    
    override func render() {
        contentView.addSubview(containerView)
        containerView.addSubViews([goalAchievementRateView, titleLabel,
                                      calendarImageView, termLabel])
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(96)
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(4)
        }
        
        goalAchievementRateView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(goalAchievementRateView.snp.right).offset(16)
            $0.top.equalTo(goalAchievementRateView).offset(3)
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
