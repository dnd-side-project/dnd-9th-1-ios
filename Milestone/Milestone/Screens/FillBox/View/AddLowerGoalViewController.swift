//
//  AddLowerGoalViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/17.
//

import UIKit

import SnapKit
import Then

// MARK: - 하위 목표 추가 모달뷰

class AddLowerGoalViewController: BaseViewController, ViewModelBindableType {
    
    // MARK: - SubViews
    
    lazy var backButton = UIButton()
        .then {
            $0.setImage(ImageLiteral.imgBack, for: .normal)
            $0.addTarget(self, action: #selector(dismissAddLowerGoal), for: .touchUpInside)
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
    lazy var enterGoalAlarmView = EnterGoalAlarmView()
        .then {
            $0.isModifyMode = isModifyMode
            $0.delegate = self
        }
    lazy var completeButton = RoundedButton()
        .then {
            $0.buttonComponentStyle = .primary_l
            $0.titleString = "목표 만들기 완료"
            $0.addTarget(self, action: #selector(completeAction), for: .touchUpInside)
        }
    
    // MARK: - Properties
    
    var isModifyMode = false
    var viewModel: DetailUpperViewModel!
    var delegate: UpdateLowerGoalListDelegate?
    let viewHeight = 549.0
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isModifyMode { setViewOnModifyMode() }
    }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([backButton, topicLabel, enterGoalTitleView, enterGoalAlarmView, completeButton])
        
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
        enterGoalAlarmView.snp.makeConstraints { make in
            make.top.equalTo(enterGoalTitleView.snp.bottom).offset(32)
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
    
    /// 수정하기 모드일 때 뷰 설정
    private func setViewOnModifyMode() {
        let lowerGoal = viewModel.thisLowerGoal.value
        completeButton.titleString = "목표 수정 완료"
        enterGoalTitleView.titleTextField.text = lowerGoal.title
        let arr = splitTimeStringToThree(timeString: lowerGoal.alarmTime)
        enterGoalAlarmView.selectedAmOrPm = arr?[0] ?? "오후"
        enterGoalAlarmView.selectedHour = arr?[1] ?? "01"
        enterGoalAlarmView.selectedMin = arr?[2] ?? "00"
        enterGoalAlarmView.timeButton.setTitle("\(arr?[0] ?? "오후")   \(arr?[1] ?? "01") : \(arr?[2] ?? "00")", for: .normal)
        enterGoalAlarmView.selectedDayList = lowerGoal.alarmDays.map {
            DayForResStyle(rawValue: $0)?.caseString ?? ""
        }
        enterGoalAlarmView.onOffSwitch.isOn = lowerGoal.alarmEnabled
        enterGoalAlarmView.toggleAlarmSwitch()
    }
    
    /// "오후 01:00"을 "오후", "01", "00" 3개로 split
    private func splitTimeStringToThree(timeString: String) -> [String]? {
        let components = timeString.split(separator: " ")
        if components.count == 2 {
            let timeComponents = components[1].split(separator: ":")
            if timeComponents.count == 2 {
                let period = String(components[0])
                let hour = String(timeComponents[0])
                let minute = String(timeComponents[1])
                return [period, hour, minute]
            } else {
                print("Invalid time format")
                return nil
            }
        } else {
            print("Invalid input format")
            return nil
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func dismissAddLowerGoal() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func completeAction() {
        updateButtonState(.press)
        Logger.debugDescription(self.enterGoalTitleView.titleTextField.text!)
        // req body 생성
        let lowerGoalInfo = NewLowerGoal(title: self.enterGoalTitleView.titleTextField.text!,
                                           alarmEnabled: self.enterGoalAlarmView.onOffSwitch.isOn,
                                           alarmTime: "\(self.enterGoalAlarmView.selectedAmOrPm) \(self.enterGoalAlarmView.selectedHour):\(self.enterGoalAlarmView.selectedMin)",
                                           alarmDays: self.enterGoalAlarmView.getSelectedDay())
        /// 모드에 맞게 다른 API를 호출한다
        if isModifyMode {
            viewModel.modifyLowerGoal(reqBody: lowerGoalInfo)
        } else {
            viewModel.createLowerGoal(reqBody: lowerGoalInfo)
        }
        
        // 버튼 업데이트 보여주기 위해 0.1초만 딜레이 후 dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dismiss(animated: true) {
                self.delegate?.updateLowerGoalList()
            }
        }
    }
}

// MARK: - PresentAlertDelegate

extension AddLowerGoalViewController: PresentDelegate {
    func present(_ viewController: UIViewController) {
        self.present(viewController, animated: true)
    }
    
    func present(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}

// MARK: - UpdateButtonStateDelegate

extension AddLowerGoalViewController: UpdateButtonStateDelegate {
    func updateButtonState(_ state: ButtonState) {
        self.completeButton.buttonState = state
    }
}
