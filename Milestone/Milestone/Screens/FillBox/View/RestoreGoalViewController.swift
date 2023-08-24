//
//  RestoreGoalViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/24.
//

import UIKit

import SnapKit
import Then

// MARK: - 목표 복구 팝업 뷰

class RestoreGoalViewController: BaseViewController {
    
    // MARK: - Subviews
    
    lazy var askPopUpView = AskOneOfTwoView()
        .then {
            $0.askLabel.text = "복구 하시겠어요?"
            $0.guideLabel.text = "다시 한번 힘내봐요!"
            $0.yesButton.titleString = "다시 도전 할게요"
            $0.yesButton.addTarget(self, action: #selector(restoreGoal), for: .touchUpInside)
            $0.noButton.setTitle("지금 안할래요", for: .normal)
            $0.noButton.setTitleColor(.gray04, for: .normal)
            $0.noButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubView(askPopUpView)
        
        askPopUpView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    override func configUI() {
        view.backgroundColor = .init(hex: "#000000", alpha: 0.3)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first, touch.view == view {
            dismissViewController()
        }
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func dismissViewController() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func restoreGoal() {
        self.askPopUpView.yesButton.buttonState = .press
        // 버튼 업데이트 보여주기 위해 0.1초만 딜레이 후 dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dismiss(animated: true) {
                // TODO: - 목표 복구 API 연동
            }
        }
    }
}
