//
//  BubbleTailDownView.swift
//  Milestone
//
//  Created by 서은수 on 2023/09/15.
//

import UIKit

import SnapKit
import Then

// MARK: - 가이드 말풍선 뷰 꼬리가 하단에 달린 경우

class BubbleTailDownView: UIView {
    
    // MARK: - Subviews
    
    private let tailImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgBubbleTailDown
        }
    
    lazy var guideLabel = UILabel()
        .then {
            $0.font = UIFont.pretendard(.semibold, ofSize: 14)
            $0.textColor = .white
            $0.textAlignment = .center
            $0.layer.cornerRadius = 36 / 2
            $0.backgroundColor = .gray05
            $0.clipsToBounds = true
        }
    
    // MARK: - Properties
    
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
        addSubViews([guideLabel, tailImageView])

        guideLabel.snp.makeConstraints { make in
            make.centerX.bottom.width.equalToSuperview()
            make.height.equalTo(36)
        }
        tailImageView.snp.makeConstraints { make in
            make.right.equalTo(guideLabel.snp.right).offset(-23)
            make.centerY.equalTo(guideLabel.snp.bottom)
            make.width.equalTo(18)
            make.height.equalTo(17)
        }
    }
}
