//
//  BubbleView.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/17.
//

import UIKit

import SnapKit
import Then

// MARK: - 가이드 말풍선 뷰

class BubbleView: UIView {
    
    // MARK: - Subviews
    
    private let tailImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgBubbleTail
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
            make.centerX.equalTo(guideLabel)
            make.centerY.equalTo(guideLabel.snp.top)
            make.width.equalTo(18)
            make.height.equalTo(17)
        }
    }
}
