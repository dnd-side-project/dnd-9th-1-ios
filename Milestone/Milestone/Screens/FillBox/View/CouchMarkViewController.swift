//
//  CouchMarkViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/17.
//

import UIKit

import SnapKit
import Then

// MARK: - 상위 목표 상세 화면 처음 들어왔을 때 뜨는 코치 마크 뷰

class CouchMarkViewController: BaseViewController {
    
    // MARK: - Subviews
    
    var addLowerGoalStoneView = AddLowerGoalStoneView()
        .then {
            $0.stoneImageView.image = ImageLiteral.imgAddStone
            $0.titleLabel.text = "하위 목표를 추가해주세요!"
            $0.titleLabel.textColor = .gray02
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.primary.cgColor
            $0.layer.cornerRadius = 30
        }
    var firstGuideLabel = UILabel()
        .then {
            $0.font = .pretendard(.semibold, ofSize: 16)
            $0.textColor = .white
            $0.numberOfLines = 2
            $0.setLineSpacing(lineHeightMultiple: 1.5)
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "상위 목표 안에 들어갈 하위 목표를 설정해보세요")
            attributedString.setColorForText(textForAttribute: "상위 목표 안에 들어갈", withColor: UIColor.white)
            attributedString.setColorForText(textForAttribute: "하위 목표", withColor: UIColor.secondary01)
            attributedString.setColorForText(textForAttribute: "를 설정해보세요", withColor: UIColor.white)
            $0.attributedText = attributedString
        }
    lazy var secondGuideLabel = UILabel()
        .then {
            $0.font = .pretendard(.semibold, ofSize: 16)
            $0.textColor = .white
            $0.numberOfLines = 2
            $0.setLineSpacing(lineHeightMultiple: 1.5)
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "이루기 쉽도록 작은 단위로 설정하는게 좋아요!")
            attributedString.setColorForText(textForAttribute: "이루기 쉽도록", withColor: UIColor.white)
            attributedString.setColorForText(textForAttribute: "작은 단위", withColor: UIColor.secondary01)
            attributedString.setColorForText(textForAttribute: "로 설정하는게 좋아요!", withColor: UIColor.white)
            $0.attributedText = attributedString
        }
    lazy var mileImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgMile
        }
    lazy var xButton = UIButton()
        .then {
            $0.setImage(ImageLiteral.imgWhiteBigX, for: .normal)
            $0.addTarget(self, action: #selector(dismissCouchMark), for: .touchUpInside)
        }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first, touch.view == view || touch.view == addLowerGoalStoneView {
            dismiss(animated: true) // 배경 클릭 시 dismiss
        }
    }
    
    override func render() {
        view.addSubViews([addLowerGoalStoneView, firstGuideLabel, secondGuideLabel, mileImageView, xButton])
        
        addLowerGoalStoneView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(146)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo((UIScreen.main.bounds.width - 48 - 16 - 4) / 3)
            make.height.equalTo(148 - 4)
        }
        firstGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(addLowerGoalStoneView).offset(30)
            make.left.equalTo(addLowerGoalStoneView.snp.right).offset(16)
            make.width.equalTo(160)
        }
        secondGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(firstGuideLabel.snp.bottom).offset(20)
            make.left.equalTo(firstGuideLabel)
            make.width.equalTo(165)
        }
        mileImageView.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().inset(32)
            make.width.height.equalTo(200)
        }
        xButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(57)
            make.right.equalToSuperview().inset(41)
            make.width.height.equalTo(38)
        }
    }
    
    override func configUI() {
        view.backgroundColor = .init(hex: "#000000", alpha: 0.6)
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func dismissCouchMark() {
        dismiss(animated: true)
    }
}
