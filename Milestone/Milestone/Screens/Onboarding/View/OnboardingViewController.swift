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

class OnboardingViewController: BaseViewController {
    
    var coordinator: OnboardingFlow?
    
    private var startDate = Date()
    private var endDate = Date()
    
    private let mainLabel = UILabel()
        .then {
            $0.text = "이루고 싶은\n목표를 적어주세요!"
            $0.numberOfLines = 0
            $0.font = UIFont.pretendard(.bold, ofSize: 28)
            $0.textAlignment = .left
        }
    
    private let titleLabel = UILabel()
        .then {
            $0.text = "제목"
            $0.font = UIFont.pretendard(.semibold, ofSize: 16)
        }
    
    private let titleTextField = UITextField()
        .then {
            $0.font = UIFont.pretendard(.semibold, ofSize: 16)
            $0.placeholder = "제목을 입력해주세요!"
            $0.layer.cornerRadius = 10
            $0.backgroundColor = UIColor.gray01
        }
    
    private let dateLabel = UILabel()
        .then {
            $0.text = "날짜를 설정해주세요"
            $0.font = UIFont.pretendard(.semibold, ofSize: 16)
        }
    
    private let startDateLabel = UILabel()
        .then {
            $0.text = "시작일"
            $0.font = UIFont.pretendard(.regular, ofSize: 12)
        }
    
    private let startDateButton = UIButton(type: .system)
        .then {
            $0.backgroundColor = .gray01
            $0.titleLabel?.font = UIFont.pretendard(.semibold, ofSize: 16)
            $0.layer.cornerRadius = 10
            $0.setTitleColor(UIColor.black, for: .normal)
        }
    
    private let endDateLabel = UILabel()
        .then {
            $0.text = "종료일"
            $0.font = UIFont.pretendard(.regular, ofSize: 12)
        }
    
    private let endDateButton = UIButton(type: .system)
        .then {
            $0.backgroundColor = .gray01
            $0.titleLabel?.font = UIFont.pretendard(.semibold, ofSize: 16)
            $0.layer.cornerRadius = 10
            $0.setTitleColor(UIColor.black, for: .normal)
        }
    
    private let remindLabel = UILabel()
        .then {
            $0.text = "리마인드 알림"
            $0.font = UIFont.pretendard(.semibold, ofSize: 16)
        }
    
    private let remindInformationLabel = UILabel()
        .then {
            $0.numberOfLines = 0
            $0.textColor = .primary
            $0.font = UIFont.pretendard(.regular, ofSize: 14)
            $0.text = "목표를 잊지 않도록 랜덤한 시간에\n앱 알림을 통해 리마인드 시켜드려요!"
            $0.setLineSpacing(lineSpacing: 1.5)
        }
    
    private let remindAdditionalInformationLabel = UILabel()
        .then {
            $0.text = "언제든 설정 화면에서 리마인드 알림을 끌 수 있어요."
            $0.textColor = .gray03
            $0.font = UIFont.pretendard(.regular, ofSize: 12)
        }
    
    private let remindToggleButton = UISwitch()
        .then {
            $0.onTintColor = .primary
        }
    
    private let completeButton = UIButton(type: .system)
        .then {
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .gray06
            $0.setTitleColor(UIColor.white, for: .normal)
            $0.setTitle("목표 만들기 완료", for: .normal)
            $0.titleLabel?.font = UIFont.pretendard(.semibold, ofSize: 16)
            $0.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        }
    
    @objc func completeButtonTapped(_ sender: UIButton) {
        coordinator?.coordinateToNext()
    }
    
    override func render() {
        self.view.addSubViews([mainLabel, titleLabel, titleTextField, dateLabel, startDateLabel, startDateButton, endDateLabel, endDateButton, remindLabel, remindInformationLabel, remindAdditionalInformationLabel, remindToggleButton, completeButton])
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(100)
            make.leading.equalTo(self.view.snp.leading).offset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(48)
            make.leading.equalTo(self.view.snp.leading).offset(24)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(self.view.snp.leading).offset(24)
            make.trailing.equalTo(self.view.snp.trailing).offset(-24)
            make.height.equalTo(46)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(40)
            make.leading.equalTo(self.view.snp.leading).offset(24)
        }
        
        startDateLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.leading.equalTo(self.view.snp.leading).offset(24)
        }
        
        startDateButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(24)
            make.top.equalTo(startDateLabel.snp.bottom).offset(8)
            make.trailing.equalTo(view.snp.centerX).offset(-10)
            make.height.equalTo(46)
        }
        
        endDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.centerX).offset(10)
            make.top.equalTo(startDateLabel.snp.top)
        }
        
        endDateButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.centerX).offset(10)
            make.top.equalTo(startDateLabel.snp.bottom).offset(8)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(46)
        }
        
        remindLabel.snp.makeConstraints { make in
            make.top.equalTo(endDateButton.snp.bottom).offset(24)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
        
        remindInformationLabel.snp.makeConstraints { make in
            make.top.equalTo(remindLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
        
        remindAdditionalInformationLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(24)
            make.top.equalTo(remindInformationLabel.snp.bottom).offset(4)
        }
        
        remindToggleButton.snp.makeConstraints { make in
            make.top.equalTo(remindLabel)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
        }
        
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(54)
        }
    }
    
    override func configUI() {
        self.view.backgroundColor = .systemBackground
        
        titleTextField.setLeftPaddingPoints(16)
        
        startDateButton.setTitle(getDateString(), for: .normal)
        endDateButton.setTitle(getDateString(), for: .normal)
        
        setupDateButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupDateButton() {
        startDateButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .date
                datePicker.preferredDatePickerStyle = .wheels
                datePicker.locale = Locale(identifier: "ko_KR")
                
                if let startDate = self?.startDate {
                    datePicker.date = startDate
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy / MM / dd"
                
                let alert = UIAlertController(title: "", message: "날짜를 골라주세요", preferredStyle: .actionSheet)
                let tapAction = UIAlertAction(title: "선택 완료", style: .cancel) { _ in
                    self?.startDate = datePicker.date
                    
                    if let endDate = self?.endDate,
                       endDate < datePicker.date {
                        self?.startDateButton.setTitle("\(dateFormatter.string(from: endDate))", for: .normal)
                        self?.startDate = endDate
                    } else {
                        self?.startDateButton.setTitle("\(dateFormatter.string(from: datePicker.date))", for: .normal)
                    }
                }
                        
                alert.addAction(tapAction)
                
                let vc = UIViewController()
                vc.view = datePicker
                        
                alert.setValue(vc, forKey: "contentViewController")
                        
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        endDateButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .date
                datePicker.preferredDatePickerStyle = .wheels
                datePicker.locale = Locale(identifier: "ko_KR")
                
                if let endDate = self?.endDate {
                    datePicker.date = endDate
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy / MM / dd"
                
                let alert = UIAlertController(title: "", message: "날짜를 골라주세요", preferredStyle: .actionSheet)
                let tapAction = UIAlertAction(title: "선택 완료", style: .cancel) { _ in
                    self?.endDate = datePicker.date
                    
                    if let startDate = self?.startDate, datePicker.date < startDate {
                        self?.endDate = startDate
                        self?.endDateButton.setTitle("\(dateFormatter.string(from: startDate))", for: .normal)
                    } else {
                        self?.endDateButton.setTitle("\(dateFormatter.string(from: datePicker.date))", for: .normal)
                    }
                }
                
                alert.addAction(tapAction)
                
                let vc = UIViewController()
                vc.view = datePicker
                        
                alert.setValue(vc, forKey: "contentViewController")
                        
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy / MM / dd"
        
        return dateFormatter.string(from: Date())
    }
}
