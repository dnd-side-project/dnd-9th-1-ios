//
//  GoalStatusView.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/11.
//

import UIKit

import SnapKit
import Then

// MARK: - 상위 목표의 진행 상황을 알려주는 뷰

class GoalStatusView: UIView {
    
    // MARK: - Subviews
    
    public var titleLabel = UILabel()
        .then {
            $0.text = "진행 중 목표"
            $0.font = .pretendard(.semibold, ofSize: 14)
            $0.textColor = .black
            $0.textAlignment = .center
        }
    
    public var stoneImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgTempStone
        }
    
    public var goalNumberLabel = UILabel()
        .then {
            $0.text = "4"
            $0.font = .pretendard(.semibold, ofSize: 16)
            $0.textColor = .black
            $0.textAlignment = .center
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
    
    private func configUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
    }
    
    private func render() {
        addSubViews([titleLabel, stoneImageView, goalNumberLabel])
        
        self.snp.makeConstraints { make in
            make.width.equalTo((UIScreen.main.bounds.width - (48 + 14)) / 2)
            make.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.centerX.equalToSuperview()
        }
        
        stoneImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(titleLabel).offset(9.5)
            $0.width.height.equalTo(24)
        }
        
        goalNumberLabel.snp.makeConstraints {
            $0.left.equalTo(stoneImageView.snp.right).offset(8)
            $0.centerY.equalTo(stoneImageView)
        }
    }
}
