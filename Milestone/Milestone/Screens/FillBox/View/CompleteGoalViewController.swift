//
//  CompleteGoalViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/19.
//

import UIKit

import SnapKit
import Then

// MARK: - 목표 완료 시 팝업 뷰

class CompleteGoalViewController: BaseViewController {
    
    // MARK: - Subviews
    
    private lazy var completePopUpView = CompleteView()
        .then {
            $0.alertImageView.image = ImageLiteral.imgCompleteGoal
            let stringValue = "목표 달성을 축하드려요!"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
            attributedString.setColorForText(textForAttribute: "목표 달성", withColor: .pointPurple)
            attributedString.setColorForText(textForAttribute: "을 축하드려요!", withColor: .black)
            $0.completeLabel.attributedText = attributedString
            $0.completeInformationLabel.text = "3번째 보석을 찾으셨네요!"
            $0.completeInformationLabel.textColor = .black
            $0.closeButton.addTarget(self, action: #selector(dismissCompleteGoal), for: .touchUpInside)
            // TODO: - 추후 코디네이터 패턴 적용하면서 버튼 이벤트 연결
//            $0.goToButton.addTarget(self, action: #selector(), for: .touchUpInside)
        }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first, touch.view == view {
            dismiss(animated: true) // 배경 클릭 시 dismiss
        }
    }
    
    override func render() {
        view.addSubView(completePopUpView)
        
        completePopUpView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configUI() {
        view.backgroundColor = UIColor.init(hex: "#000000").withAlphaComponent(0.3)
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func dismissCompleteGoal() {
        dismiss(animated: true)
    }
}
