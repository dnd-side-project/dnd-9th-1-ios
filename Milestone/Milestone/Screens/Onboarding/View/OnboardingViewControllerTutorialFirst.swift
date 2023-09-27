//
//  OnboardingViewController.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/13.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class OnboardingViewControllerTutorialFirst: BaseViewController {
    
    // MARK: - SubViews
    
    lazy var backButton = UIButton()
        .then {
            $0.setImage(ImageLiteral.imgBack, for: .normal)
            $0.addTarget(self, action: #selector(dismissAddParentGoal), for: .touchUpInside)
        }
    
    var topicLabel = UILabel()
        .then {
            $0.numberOfLines = 0
            $0.text = "이루고 싶은\n목표를 적어주세요!"
            $0.font = .pretendard(.bold, ofSize: 28)
            $0.textAlignment = .left
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
    
    lazy var completeButton = RoundedButton()
        .then {
            $0.buttonComponentStyle = .primary_l
            $0.titleString = "목표 만들기 완료"
            $0.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        }
    
    // MARK: Properties
    var coordinator: OnboardingFlow?
    var viewModel: OnboardingViewModel!
    
    // MARK: Function
    
    override func render() {
        view.addSubViews([backButton, topicLabel, enterGoalTitleView, enterGoalDateView, reminderAlarmView, completeButton])
        
        topicLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.leading.equalToSuperview().offset(24)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        enterGoalTitleView.titleTextField.endEditing(true)
    }
    
    // MARK: Objc functions
    @objc func completeButtonTapped(_ sender: UIButton) {
        updateButtonState(.press)
        
        let upperGoal = CreateUpperGoal(title: enterGoalTitleView.titleTextField.text ?? "", startDate: enterGoalDateView.startDateButton.titleLabel?.text ?? "", endDate: enterGoalDateView.endDateButton.titleLabel?.text ?? "", reminderEnabled: reminderAlarmView.onOffSwitch.isOn)
        
        viewModel.addUpperGoal(goal: upperGoal)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    print("SUC")
                    self?.coordinator?.coordinateToTutorialLast()
                case .failure:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    private func dismissAddParentGoal() {
        self.dismiss(animated: true)
    }
}

// MARK: - PresentAlertDelegate

extension OnboardingViewControllerTutorialFirst: PresentDelegate {
    func present(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    func present(_ viewController: UIViewController) {
        self.present(viewController, animated: true)
    }
}

// MARK: - UpdateButtonStateDelegate

extension OnboardingViewControllerTutorialFirst: UpdateButtonStateDelegate {
    func updateButtonState(_ state: ButtonState) {
        self.completeButton.buttonState = state
    }
}
