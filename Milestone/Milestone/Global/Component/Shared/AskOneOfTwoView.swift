//
//  AskOneOfTwoView.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/19.
//

import UIKit

import SnapKit
import Then

// MARK: - 정말 삭제하시겠어요? 또는 복구하시겠어요? 와 같은 질문을 통해 2개 중 하나의 답변을 기다리는 뷰

class AskOneOfTwoView: UIView {
    
    // MARK: - Subviews
    
    var askLabel = UILabel()
        .then {
            $0.textColor = .black
            $0.font = .pretendard(.semibold, ofSize: 22)
            $0.textAlignment = .center
        }
    var guideLabel = UILabel()
        .then {
            $0.textColor = .gray05
            $0.font = .pretendard(.regular, ofSize: 16)
            $0.textAlignment = .center
        }
    var yesButton = UIButton()
        .then {
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .gray01
            $0.setTitleColor(.gray04, for: .normal)
            $0.titleLabel?.font = .pretendard(.semibold, ofSize: 16)
        }
    var noButton = UIButton()
        .then {
            $0.titleLabel?.font = .pretendard(.semibold, ofSize: 16)
            $0.setTitleColor(.primary, for: .normal)
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
        addSubViews([askLabel, guideLabel, yesButton, noButton])
        
        self.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(235)
        }
        askLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(askLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        yesButton.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        noButton.snp.makeConstraints { make in
            make.top.equalTo(yesButton.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }
    }
    private func configUI() {
        backgroundColor = .white
        layer.cornerRadius = 20
        makeShadow(color: .init(hex: "#464646", alpha: 0.4), alpha: 1, x: 0, y: 8, blur: 10, spread: 0)
    }
}
