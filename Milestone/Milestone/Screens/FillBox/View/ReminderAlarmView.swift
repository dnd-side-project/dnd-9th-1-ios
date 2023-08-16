//
//  ReminderAlarmView.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/15.
//

import UIKit

import SnapKit
import Then

// MARK: - 목표 리마인드 알림 설정 뷰

class ReminderAlarmView: UIView {
    
    // MARK: - Subviews
    
    let guideLabel = UILabel()
        .then {
            $0.text = "리마인드 알림"
            $0.textAlignment = .left
            $0.font = .pretendard(.semibold, ofSize: 16)
            $0.textColor = .black
        }
    lazy var detailGuideLabel = UILabel()
        .then {
            $0.text = "목표를 잊지 않도록 랜덤한 시간에\n앱 알림을 통해 리마인드 시켜드려요!"
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.setLineSpacing(lineHeightMultiple: 1.3)
            $0.font = .pretendard(.regular, ofSize: 14)
            $0.textColor = .primary
        }
    lazy var onOffGuideLabel = UILabel()
        .then {
            $0.text = "언제든 설정 화면에서 리마인드 알림을 끌 수 있어요."
            $0.textAlignment = .left
            $0.font = .pretendard(.regular, ofSize: 12)
            $0.textColor = .gray03
        }
    lazy var onOffSwitch = UISwitch()
        .then {
            $0.onTintColor = .primary
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        render()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func render() {
        addSubViews([guideLabel, detailGuideLabel, onOffGuideLabel, onOffSwitch])
        
        self.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(92)
        }
        guideLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        detailGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(6)
            make.left.equalToSuperview()
            make.width.equalTo(279)
        }
        onOffGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(detailGuideLabel.snp.bottom).offset(6)
            make.left.equalToSuperview()
            make.width.equalTo(279)
            make.height.equalTo(16)
        }
        onOffSwitch.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
        }
    }
}
