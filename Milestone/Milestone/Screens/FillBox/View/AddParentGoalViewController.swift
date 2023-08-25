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

class AddParentGoalViewController: BaseViewController, ViewModelBindableType {
    
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
    lazy var completeButton = RoundedButton()
        .then {
            $0.buttonComponentStyle = .primary_l
            $0.titleString = "목표 만들기 완료"
        }
    
    // MARK: - Properties
    
    var isModifyMode = false
    var viewModel: AddParentGoalViewModel!
    let viewHeight = 549.0
    var delegate: UpdateParentGoalListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCompleteButtonAction()
    }
    
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
    
    /// 완료 버튼 액션 설정
    private func setCompleteButtonAction() {
        if isModifyMode {
            completeButton.addTarget(self, action: #selector(completeModifyParentGoal), for: .touchUpInside)
        } else {
            completeButton.addTarget(self, action: #selector(completeAddParentGoal), for: .touchUpInside)
        }
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func dismissAddParentGoal() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func completeAddParentGoal() {
        // 상위 목표 생성 API 호출
        let reqBody = CreateParentGoal(title: self.enterGoalTitleView.titleTextField.text ?? " ", startDate: self.enterGoalDateView.startDateButton.titleLabel?.text ?? "", endDate: self.enterGoalDateView.endDateButton.titleLabel?.text ?? "", reminderEnabled: self.reminderAlarmView.onOffSwitch.isOn)
        viewModel.createParentGoal(reqBody: reqBody)
        
        updateButtonState(.press)
        // 버튼 업데이트 보여주기 위해 0.1초만 딜레이 후 dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dismiss(animated: true) {
                // 목표 추가 모달 dismiss 하면서 상위 목표 목록 업데이트
                self.delegate?.updateParentGoalList()
            }
        }
    }
    
    @objc
    private func completeModifyParentGoal() {
        let title = self.enterGoalTitleView.titleTextField.text ?? ""
        let startDate = self.enterGoalDateView.startDateButton.titleLabel?.text ?? ""
        let endDate = self.enterGoalDateView.endDateButton.titleLabel?.text ?? ""
        let reminderEnabled = self.reminderAlarmView.onOffSwitch.isOn
        // 상위 목표 수정 API 호출
        let reqBody = Goal(identity: viewModel.parentGoalId, title: title, startDate: startDate, endDate: endDate, reminderEnabled: reminderEnabled)
        viewModel.modifyParentGoal(reqBody: reqBody)
        
        updateButtonState(.press)
        // 버튼 업데이트 보여주기 위해 0.1초만 딜레이 후 dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dismiss(animated: true) {
                // 목표 추가 모달 dismiss 하면서 상위 목표 목록 업데이트
//                self.delegate?.updateParentGoalList()
            }
        }
    }
}

// MARK: - PresentAlertDelegate

extension AddParentGoalViewController: PresentDelegate {
    func present(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    func present(_ viewController: UIViewController) {
        self.present(viewController, animated: true)
    }
}

// MARK: - UpdateButtonStateDelegate

extension AddParentGoalViewController: UpdateButtonStateDelegate {
    func updateButtonState(_ state: ButtonState) {
        self.completeButton.buttonState = state
    }
}
