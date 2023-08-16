//
//  AddParentGoalViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/15.
//

import UIKit

import RxCocoa
import RxSwift
import Then

// MARK: - 상위 목표 추가 모달뷰

/// Alert를 present 해주는 델리게이트 패턴
/// UIView에서 present 시 사용함
protocol PresentAlertDelegate: AnyObject {
    func present(alert: UIAlertController)
}

class AddParentGoalViewController: BaseViewController {
    
    // MARK: - SubViews
    
    lazy var backButton = UIButton()
        .then {
            $0.setImage(ImageLiteral.imgBack, for: .normal)
            $0.addTarget(self, action: #selector(pop), for: .touchUpInside)
        }
    var topicLabel = UILabel()
        .then {
            $0.text = "목표 설정"
            $0.font = .pretendard(.semibold, ofSize: 18)
            $0.textAlignment = .center
        }
    var enterGoalTitleView = EnterGoalTitleView()
    lazy var enterGoalDateView = EnterGoalDateView()
        .then {
            $0.delegate = self
        }
    var reminderAlarmView = ReminderAlarmView()
    var completeButton = RoundedDarkButton()
    
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
        
        completeButton.titleString = "목표 만들기 완료"
    }
}

// MARK: - PresentAlertDelegate

extension AddParentGoalViewController: PresentAlertDelegate {
    func present(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}
