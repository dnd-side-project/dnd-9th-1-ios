//
//  AddParentGoalViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/15.
//

import UIKit

import SnapKit
import Then

// MARK: - 상위 목표 추가 모달뷰

/// Alert를 present 해주는 델리게이트 패턴
/// 서브뷰에서 present 시 사용함
protocol PresentAlertDelegate: AnyObject {
    func present(alert: UIAlertController)
    func present(vc: UIViewController)
}

/// 버튼의 상태를 업데이트 해주는 델리게이트 패턴
/// 서브뷰에서 버튼의 상태를 업데이트 할 때 사용함
protocol UpdateButtonStateDelegate: AnyObject {
    func updateButtonState(_ state: ButtonState)
}

class AddParentGoalViewController: BaseViewController {
    
    // MARK: - SubViews
    
    lazy var backButton = UIButton()
        .then {
            $0.setImage(ImageLiteral.imgBack, for: .normal)
            $0.addTarget(self, action: #selector(dismissAddParentGoal), for: .touchUpInside)
        }
    var topicLabel = UILabel()
        .then {
            $0.text = "목표 설정"
            $0.font = .pretendard(.semibold, ofSize: 18)
            $0.textAlignment = .center
        }
    lazy var enterGoalTitleView = EnterGoalTitleView()
        .then {
            $0.delegate = self
        }
    lazy var enterGoalDateView = EnterGoalDateView()
        .then {
            $0.presentDelegate = self
            $0.buttonStateDelegate = self
        }
    var reminderAlarmView = ReminderAlarmView()
    lazy var completeButton = RoundedDarkButton()
        .then {
            $0.titleString = "목표 만들기 완료"
            $0.addTarget(self, action: #selector(completeAddParentGoal), for: .touchUpInside)
        }
    
    // MARK: - Properties
    
    let viewHeight = 549.0
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([backButton, topicLabel, enterGoalTitleView, enterGoalDateView, reminderAlarmView, completeButton])
        
        view.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalTo(28)
            make.left.equalTo(32)
            make.width.equalTo(9)
            make.height.equalTo(17)
        }
        topicLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        enterGoalTitleView.snp.makeConstraints { make in
            make.top.equalTo(topicLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        enterGoalDateView.snp.makeConstraints { make in
            make.top.equalTo(enterGoalTitleView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        reminderAlarmView.snp.makeConstraints { make in
            make.top.equalTo(enterGoalDateView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        completeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(54)
        }
    }

    override func configUI() {
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 20
        view.makeShadow(color: .init(hex: "#464646", alpha: 0.2), alpha: 1, x: 0, y: -10, blur: 20, spread: 0)
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func dismissAddParentGoal() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func completeAddParentGoal() {
        updateButtonState(.press)
        
        // 버튼 업데이트 보여주기 위해 0.1초만 딜레이 후 dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dismiss(animated: true)
        }
    }
}

// MARK: - PresentAlertDelegate

extension AddParentGoalViewController: PresentAlertDelegate {
    func present(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    func present(vc: UIViewController) {
        self.present(vc, animated: true)
    }
}

// MARK: - UpdateButtonStateDelegate

extension AddParentGoalViewController: UpdateButtonStateDelegate {
    func updateButtonState(_ state: ButtonState) {
        self.completeButton.buttonState = state
    }
}
