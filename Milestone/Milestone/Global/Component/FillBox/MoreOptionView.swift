//
//  MoreOptionView.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/14.
//

import UIKit

import SnapKit
import Then

// MARK: - 더보기 화면에서 단일 옵션을 나타내는 뷰

class MoreOptionView: UIView {
    
    // MARK: - Subviews
    
    var iconImageView = UIImageView()
    var optionLabel = UILabel()
        .then {
            $0.font = .pretendard(.semibold, ofSize: 16)
            $0.textColor = .black
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
        addSubViews([iconImageView, optionLabel])
        
        self.snp.makeConstraints { make in
            make.width.equalTo(143)
            make.height.equalTo(24)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.height.equalTo(24)
        }
        optionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.left.equalTo(iconImageView.snp.right).offset(12)
        }
    }
    
    private func configUI() {
        self.backgroundColor = .white
    }
}
