//
//  EnterGoalDateView.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/15.
//

import UIKit

import SnapKit
import Then

// MARK: - 상위 목표 기간 설정 뷰

class EnterGoalDateView: UIView {
    
    // MARK: - Subviews
    
    let guideLabel = UILabel()
        .then {
            $0.text = "날짜를 설정해주세요"
            $0.textAlignment = .left
            $0.font = .pretendard(.semibold, ofSize: 16)
            $0.textColor = .black
        }
    let startDateLabel = UILabel()
        .then {
            $0.text = "시작일"
            $0.textAlignment = .left
            $0.font = .pretendard(.regular, ofSize: 12)
        }
    lazy var startDateButton = UIButton(type: .system)
        .then {
            $0.backgroundColor = .gray01
            $0.layer.cornerRadius = 10
            $0.setTitle("2023 / 08 / 15", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont.pretendard(.semibold, ofSize: 16)
        }
    let endDateLabel = UILabel()
        .then {
            $0.text = "종료일"
            $0.font = .pretendard(.regular, ofSize: 12)
        }
    lazy var endDateButton = UIButton()
        .then {
            $0.backgroundColor = .gray01
            $0.layer.cornerRadius = 10
            $0.setTitle("2023 / 08 / 15", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont.pretendard(.semibold, ofSize: 16)
        }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        render()
        configUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func render() {
        addSubViews([guideLabel, startDateLabel, startDateButton, endDateLabel, endDateButton])
        
        self.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(104)
        }
        guideLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        startDateLabel.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.width.equalTo(159)
        }
        startDateButton.snp.makeConstraints { make in
            make.top.equalTo(startDateLabel.snp.bottom).offset(8)
            make.left.equalTo(startDateLabel)
            make.width.equalTo(160)
            make.height.equalTo(46)
        }
        endDateLabel.snp.makeConstraints { make in
            make.left.equalTo(startDateLabel.snp.right).offset(22)
            make.centerY.equalTo(startDateLabel)
        }
        endDateButton.snp.makeConstraints { make in
            make.top.equalTo(endDateLabel.snp.bottom).offset(8)
            make.left.equalTo(endDateLabel)
            make.width.equalTo(160)
            make.height.equalTo(46)
        }
    }
    
    private func configUI() {
        backgroundColor = .white
    }
}
