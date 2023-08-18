//
//  ReviewCompleteViewController.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/17.
//

import UIKit

class ReviewCompleteViewController: BaseViewController {
    // MARK: SubViews
    let backgroundView = UIView()
        .then {
            $0.backgroundColor = .black.withAlphaComponent(0.3)
        }
    
    let alertBox = UIView()
        .then {
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .white
        }
    
    let alertImageView = UIImageView()
        .then {
            $0.layer.cornerRadius = 20
            $0.image = ImageLiteral.imgPlaceholder
        }
    
    let closeButton = UIButton(type: .system)
        .then {
            $0.titleLabel?.font = .pretendard(.semibold, ofSize: 16)
            $0.setBackgroundImage(ImageLiteral.imgClose, for: .normal)
        }
    
    let completeLabel = UILabel()
        .then {
            $0.textColor = .init(hex: "#222222")
            $0.textAlignment = .center
            $0.font = .pretendard(.semibold, ofSize: 22)
            $0.text = "회고 작성이 완료되었어요!"
        }
    
    let completeInformationLabel = UILabel()
        .then {
            $0.font = .pretendard(.regular, ofSize: 16)
            $0.textColor = .init(hex: "#554F49")
            $0.text = "작성된 회고는 완료함에서 확인하세요"
        }
    
    let button = UIButton(type: .system)
        .then {
            $0.titleLabel?.font = .pretendard(.semibold, ofSize: 16)
            $0.layer.cornerRadius = 20
            $0.setTitle("완료함 가기", for: .normal)
            $0.setTitleColor(.primary, for: .normal)
            $0.backgroundColor = .secondary03
        }
    
    // MARK: Properties
    
    // MARK: Life Cycles
    
    // MARK: Functions
    
    override func render() {
        view.addSubView(backgroundView)
        backgroundView.addSubView(alertBox)
        alertBox.addSubViews([alertImageView, closeButton, completeLabel, completeInformationLabel, button])
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        alertBox.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundView.snp.centerX)
            make.centerY.equalTo(backgroundView.snp.centerY)
            make.width.equalTo(342)
            make.height.equalTo(312)
        }
        
        alertImageView.snp.makeConstraints { make in
            make.top.equalTo(alertBox.snp.top).offset(24)
            make.centerX.equalTo(alertBox.snp.centerX)
            make.width.equalTo(194)
            make.height.equalTo(130)
        }
        
        closeButton.snp.makeConstraints { make in
            make.trailing.equalTo(alertBox.snp.trailing).offset(-24)
            make.top.equalTo(alertImageView.snp.top)
        }
        
        completeLabel.snp.makeConstraints { make in
            make.top.equalTo(alertImageView.snp.bottom).offset(8)
            make.centerX.equalTo(alertBox.snp.centerX)
        }
        
        completeInformationLabel.snp.makeConstraints { make in
            make.top.equalTo(completeLabel.snp.bottom).offset(8)
            make.centerX.equalTo(alertBox.snp.centerX)
        }
        
        button.snp.makeConstraints { make in
            make.bottom.equalTo(alertBox.snp.bottom).offset(-24)
            make.height.equalTo(54)
            make.leading.equalTo(alertBox.snp.leading).offset(24)
            make.trailing.equalTo(alertBox.snp.trailing).offset(-24)
        }
    }
}
