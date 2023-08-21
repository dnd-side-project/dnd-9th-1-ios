//
//  CompleteView.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/17.
//

import UIKit

import SnapKit
import Then

// MARK: - 목표 완료, 회고 완료 시 뜨는 팝업 뷰

class CompleteView: UIView {

    // MARK: - Subviews
    
    var alertImageView = UIImageView()
        .then {
            $0.layer.cornerRadius = 20 // TEMP
            $0.image = ImageLiteral.imgPlaceholder
        }
    var closeButton = UIButton(type: .system)
        .then {
            $0.setBackgroundImage(ImageLiteral.imgX, for: .normal)
        }
    var completeLabel = UILabel()
        .then {
            $0.textColor = .init(hex: "#222222")
            $0.textAlignment = .center
            $0.font = .pretendard(.semibold, ofSize: 22)
            $0.text = "회고 작성이 완료되었어요!"
        }
    var completeInformationLabel = UILabel()
        .then {
            $0.font = .pretendard(.regular, ofSize: 16)
            $0.textColor = .init(hex: "#554F49")
            $0.text = "작성된 회고는 완료함에서 확인하세요"
        }
    var goToButton = UIButton(type: .system)
        .then {
            $0.layer.cornerRadius = 20
            $0.setTitle("완료함 가기", for: .normal)
            $0.setTitleColor(.primary, for: .normal)
            $0.titleLabel?.font = .pretendard(.semibold, ofSize: 16)
            $0.backgroundColor = .secondary03
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
        addSubViews([alertImageView, closeButton, completeLabel, completeInformationLabel, goToButton])
        
        self.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(306)
        }
        alertImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(194)
            make.height.equalTo(130)
        }
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalTo(alertImageView)
            make.width.height.equalTo(24)
        }
        completeLabel.snp.makeConstraints { make in
            make.top.equalTo(alertImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        completeInformationLabel.snp.makeConstraints { make in
            make.top.equalTo(completeLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        goToButton.snp.makeConstraints { make in
            make.top.equalTo(completeInformationLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func configUI() {
        backgroundColor = .white
        layer.cornerRadius = 20
        makeShadow(color: .init(hex: "#464646", alpha: 0.4), alpha: 1, x: 0, y: 8, blur: 10, spread: 0)
    }
}
