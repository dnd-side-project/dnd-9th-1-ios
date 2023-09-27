//
//  ResetGoalViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/24.
//

import UIKit

import SnapKit
import Then

// MARK: - 목표 복구 시 목표 정보 재설정 모달 뷰

class ResetGoalViewController: BaseViewController, ViewModelBindableType {
    
    // MARK: - SubViews
    
    lazy var backButton = UIButton()
        .then {
            $0.setImage(ImageLiteral.imgBack, for: .normal)
            $0.addTarget(self, action: #selector(dismissAddUpperGoal), for: .touchUpInside)
        }
    var topicLabel = UILabel()
        .then {
            $0.text = "목표 설정"
            $0.font = .pretendard(.semibold, ofSize: 18)
            $0.textAlignment = .center
        }
    lazy var enterGoalDateView = EnterGoalDateView()
        .then {
            $0.guideLabel.text = "새로운 날짜를 설정해주세요"
            $0.presentDelegate = self
            $0.buttonStateDelegate = self
        }
    var reminderAlarmView = ReminderAlarmView()
    lazy var restoreButton = RoundedButton()
        .then {
            $0.buttonComponentStyle = .primary_l
            $0.buttonState = .original
            $0.titleString = "복구하기"
            $0.addTarget(self, action: #selector(restoreGoal), for: .touchUpInside)
        }
    
    // MARK: - Properties
    
    let viewHeight = 428.0
    var viewModel: DetailUpperViewModel!
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([backButton, topicLabel, enterGoalDateView, reminderAlarmView, restoreButton])
        
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
        enterGoalDateView.snp.makeConstraints { make in
            make.top.equalTo(topicLabel.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
        }
        reminderAlarmView.snp.makeConstraints { make in
            make.top.equalTo(enterGoalDateView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        restoreButton.snp.makeConstraints { make in
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
    private func dismissAddUpperGoal() {
        self.dismiss(animated: true)
    }

    @objc
    private func restoreGoal() {
        // 복구하기 API 호출
        viewModel.restoreUpperGoal(reqBody: Goal(identity: nil,
                                                  title: nil,
                                                  startDate: enterGoalDateView.startDateButton.titleLabel?.text ?? "",
                                                  endDate: enterGoalDateView.endDateButton.titleLabel?.text ?? "",
                                                  reminderEnabled: reminderAlarmView.onOffSwitch.isOn))
        updateButtonState(.press)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.dismiss(animated: true)
            self.viewModel?.popDetailUpperVC.accept(true)
        }
    }
}

// MARK: - PresentAlertDelegate

extension ResetGoalViewController: PresentDelegate {
    func present(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    func present(_ viewController: UIViewController) {
        self.present(viewController, animated: true)
    }
}

// MARK: - UpdateButtonStateDelegate

extension ResetGoalViewController: UpdateButtonStateDelegate {
    func updateButtonState(_ state: ButtonState) {
        self.restoreButton.buttonState = state
    }
}
