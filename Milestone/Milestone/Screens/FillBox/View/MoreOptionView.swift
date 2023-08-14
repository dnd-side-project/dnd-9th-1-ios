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
    
    public var circleView = UIView()
        .then {
            $0.backgroundColor = .gray02
            $0.layer.cornerRadius = 24 / 2
        }
    public var optionLabel = UILabel()
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
        addSubViews([circleView, optionLabel])
        
        self.snp.makeConstraints { make in
            make.width.equalTo(143)
            make.height.equalTo(24)
        }
        circleView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.height.equalTo(24)
        }
        optionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(circleView)
            make.left.equalTo(circleView.snp.right).offset(12)
        }
    }
    
    private func configUI() {
        self.backgroundColor = .white
    }
}
