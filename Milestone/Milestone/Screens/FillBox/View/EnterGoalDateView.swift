//
//  EnterGoalDateView.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/15.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

// MARK: - 상위 목표 기간 설정 뷰
// TODO: - 추후 리팩토링 예정......

class EnterGoalDateView: UIView {
    
    // MARK: - Subviews
    
    let guideLabel = UILabel()
        .then {
            $0.text = "날짜를 설정해주세요"
            $0.textAlignment = .left
            $0.font = .pretendard(.semibold, ofSize: 16)
            $0.textColor = .black
        }
    let startDateLabel = UILabel()
        .then {
            $0.text = "시작일"
            $0.textAlignment = .left
            $0.font = .pretendard(.regular, ofSize: 12)
        }
    lazy var startDateButton = UIButton(type: .system)
        .then {
            $0.backgroundColor = .gray01
            $0.layer.cornerRadius = 10
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont.pretendard(.semibold, ofSize: 16)
            $0.addTarget(self, action: #selector(presentStartAlert), for: .touchUpInside)
            $0.setTitle("\(self.dateFormatter.string(from: startDate))", for: .normal)
        }
    let endDateLabel = UILabel()
        .then {
            $0.text = "종료일"
            $0.font = .pretendard(.regular, ofSize: 12)
        }
    lazy var endDateButton = UIButton(type: .system)
        .then {
            $0.backgroundColor = .gray01
            $0.layer.cornerRadius = 10
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont.pretendard(.semibold, ofSize: 16)
            $0.addTarget(self, action: #selector(presentEndAlert), for: .touchUpInside)
            $0.setTitle("\(dateFormatter.string(from: endDate))", for: .normal)
        }
    
    // - 1. 시작일을 위한 alert
    lazy var startDatePicker = UIDatePicker()
        .then {
            $0.datePickerMode = .date
            $0.preferredDatePickerStyle = .wheels
            $0.locale = Locale(identifier: "ko_KR")
            $0.minimumDate = startDate
            $0.date = startDate
        }
    lazy var startDateAlert = UIAlertController(title: "", message: alertMessage, preferredStyle: .actionSheet)
        .then {
            $0.addAction(completeStartDateAction)
        }
    /// 종료일 세팅하기 전에는 시작일 세팅할 때에 종료일이 + 7일인 것으로 자동 설정
    lazy var completeStartDateAction = UIAlertAction(title: "완료", style: .default) { [self] _ in
        afterEndDatePicker.date = startDatePicker.date
        endDatePicker.date = startDatePicker.date.addingTimeInterval(sevenDaysInterval)
        self.startDateButton.setTitle("\(self.dateFormatter.string(from: startDatePicker.date))", for: .normal)
        self.endDateButton.setTitle("\(dateFormatter.string(from: startDatePicker.date.addingTimeInterval(sevenDaysInterval)))", for: .normal)
    }
    // - 2. 종료일을 위한 alert
    lazy var endDatePicker = UIDatePicker()
        .then {
            $0.datePickerMode = .date
            $0.preferredDatePickerStyle = .wheels
            $0.locale = Locale(identifier: "ko_KR")
            $0.minimumDate = startDate
            $0.date = endDate
        }
    lazy var endDateAlert = UIAlertController(title: "", message: alertMessage, preferredStyle: .actionSheet)
        .then {
            $0.addAction(completeEndDateAction)
        }
    lazy var completeEndDateAction = UIAlertAction(title: "완료", style: .default) { [self] _ in
        self.endDateButton.setTitle("\(self.dateFormatter.string(from: endDatePicker.date))", for: .normal)
    }
    // - 3. 종료일 설정 이후의 시작일을 위한 alert
    lazy var afterEndDatePicker = UIDatePicker()
        .then {
            $0.datePickerMode = .date
            $0.preferredDatePickerStyle = .wheels
            $0.locale = Locale(identifier: "ko_KR")
            $0.minimumDate = startDate
            $0.date = startDate
        }
    lazy var startDateAfterEndDateSettingAlert = UIAlertController(title: "", message: alertMessage, preferredStyle: .actionSheet)
        .then {
            $0.addAction(completeStartDateAfterEndDateSettingAction)
        }
    /// 종료일 세팅한 후에는 종료일 건들지 말고 시작일만 설정
    lazy var completeStartDateAfterEndDateSettingAction = UIAlertAction(title: "완료", style: .default) { [self] _ in
        self.startDateButton.setTitle("\(self.dateFormatter.string(from: afterEndDatePicker.date))", for: .normal)
    }
        
    // MARK: - Properties
    
    var dateFormatter = DateFormatter()
        .then {
            $0.dateFormat = "yyyy / MM / dd"
        }
    var startDate = Date()
    /// 1일 = 24시간 * 60분 * 60초
    let sevenDaysInterval: TimeInterval = 7 * 24 * 60 * 60
    lazy var endDate = startDate.addingTimeInterval(sevenDaysInterval)
    var alertMessage = ""
    /// 종료일 세팅한 후인지 확인하기 위한 변수
    var isAfterEndDateSetting = false
    weak var delegate: PresentAlertDelegate?
    
    let vc = UIViewController()
    let vc2 = UIViewController()
    let vc3 = UIViewController()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        render()
        configUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func render() {
        addSubViews([guideLabel, startDateLabel, startDateButton, endDateLabel, endDateButton])
        
        self.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(104)
        }
        guideLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        startDateLabel.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.width.equalTo(159)
        }
        startDateButton.snp.makeConstraints { make in
            make.top.equalTo(startDateLabel.snp.bottom).offset(8)
            make.left.equalTo(startDateLabel)
            make.width.equalTo(160)
            make.height.equalTo(46)
        }
        endDateLabel.snp.makeConstraints { make in
            make.left.equalTo(startDateLabel.snp.right).offset(22)
            make.centerY.equalTo(startDateLabel)
        }
        endDateButton.snp.makeConstraints { make in
            make.top.equalTo(endDateLabel.snp.bottom).offset(8)
            make.left.equalTo(endDateLabel)
            make.width.equalTo(160)
            make.height.equalTo(46)
        }
    }
    
    private func configUI() {
        backgroundColor = .white
        
        vc.view = startDatePicker
        vc2.view = endDatePicker
        vc3.view = afterEndDatePicker
    }
    
    // MARK: - @objc Functions
    
    /// - 시작일 설정 버튼 클릭 시 실행
    @objc
    private func presentStartAlert() {
        alertMessage = "시작일을 선택해주세요"
        
        if isAfterEndDateSetting { // 종료일 설정 전일 때
            startDateAfterEndDateSettingAlert.setValue(vc3, forKey: "contentViewController")
            delegate?.present(alert: startDateAfterEndDateSettingAlert)
        } else { // 종료일 설정 후일 때
            startDateAlert.setValue(vc, forKey: "contentViewController")
            delegate?.present(alert: startDateAlert)
        }
    }
    
    /// - 종료일 설정 버튼 클릭 시 실행
    @objc
    private func presentEndAlert() {
        alertMessage = "종료일을 선택해주세요"
        endDateAlert.setValue(vc2, forKey: "contentViewController")
        delegate?.present(alert: endDateAlert)
        
        isAfterEndDateSetting = true
        endDateButton.setTitle(dateFormatter.string(from: endDatePicker.date), for: .normal)
    }
}