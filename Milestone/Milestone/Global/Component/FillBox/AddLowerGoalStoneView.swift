//
//  AddLowerGoalStoneView.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/17.
//

import UIKit

// MARK: - 하위 목표를 추가해주세요! 뷰 (일단은 코치마크에서만 쓰임)

class AddLowerGoalStoneView: UIView {
    lazy var stoneImageView = UIImageView()
    
    lazy var titleLabel = UILabel()
        .then {
            $0.numberOfLines = 2
            $0.font = .pretendard(.semibold, ofSize: 14)
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
    
    private func render() {
        addSubViews([stoneImageView, titleLabel])
        
        stoneImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(57)
            make.height.equalTo(61)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(stoneImageView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(8)
        }
    }
    private func configUI() {
        backgroundColor = .white
        layer.cornerRadius = 30
        
        // 그림자 설정
        layer.shadowColor = UIColor.init(hex: "#DCDCDC").cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 7 / 2.0
    }
}
