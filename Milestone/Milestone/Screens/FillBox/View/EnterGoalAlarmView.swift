//
//  EnterGoalAlarmView.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/17.
//

import UIKit

import SnapKit
import Then

struct DayData: Equatable { // TEMP
    var day: String
    var isSelected: Bool = false
}

enum Days: String {
    case MONDAY = "월"
    case TUEDAY = "화"
    case WEDDAY = "수"
    case THUDAY = "목"
    case FRIDAY = "금"
    case SATDAY = "토"
    case SUNDAY = "일"
}

// MARK: - 목표 알람 설정 뷰

class EnterGoalAlarmView: UIView {
    
    // MARK: - Subviews
    
    let guideLabel = UILabel()
        .then {
            $0.text = "알람 상태"
            $0.textAlignment = .left
            $0.font = .pretendard(.semibold, ofSize: 16)
            $0.textColor = .black
        }
    lazy var onOffSwitch = UISwitch()
        .then {
            $0.isOn = true
            $0.onTintColor = .primary
        }
    var dayButton = UIButton()
    lazy var dayStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillEqually
            for i in dayList {
                dayButton = UIButton()
                    .then {
                        $0.setTitle(i.day, for: .normal)
                        $0.titleLabel?.font = .pretendard(.semibold, ofSize: 16)
                        $0.setTitleColor(.black, for: .normal)
                        $0.backgroundColor = .gray01
                        $0.clipsToBounds = true
                        $0.layer.cornerRadius = 10
                        $0.addTarget(self, action: #selector(selectAlarmDay(_:)), for: .touchUpInside)
                        if i.day == Days.MONDAY.rawValue {
                            selectAlarmDay($0)
                        }
                    }
                $0.addArrangedSubview(dayButton)
            }
        }
    lazy var timeButton = UIButton()
        .then {
            $0.backgroundColor = .gray01
            $0.setTitle("오후   01 : 00", for: .normal)
            $0.layer.cornerRadius = 10
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .pretendard(.semibold, ofSize: 16)
            $0.addTarget(self, action: #selector(presentTimeAlert), for: .touchUpInside)
        }
    lazy var receiveAlarmLabel = UILabel()
        .then {
            $0.text = "에 알람을 받을게요!"
            $0.textAlignment = .left
            $0.font = .pretendard(.semibold, ofSize: 14)
            $0.textColor = .black
        }
    lazy var timeSelectPicker = UIDatePicker()
        .then {
            $0.datePickerMode = .time
            $0.preferredDatePickerStyle = .wheels
            $0.minuteInterval = 30
            $0.locale = Locale(identifier: "ko_KR")
        }
    lazy var timeSelectAlert = UIAlertController(title: nil, message: "시간을 선택해주세요", preferredStyle: .actionSheet)
        .then {
            $0.addAction(timeSelectAction)
        }
    lazy var timeSelectAction = UIAlertAction(title: "완료", style: .default) { [self] _ in
        timeButton.setTitle("\(dateFormatter.string(from: timeSelectPicker.date))", for: .normal)
    }
    let timeSelectViewController = UIViewController()
    
    // MARK: - Properties
    
    var dayList = [DayData(day: Days.MONDAY.rawValue), DayData(day: Days.TUEDAY.rawValue), DayData(day: Days.WEDDAY.rawValue), DayData(day: Days.THUDAY.rawValue), DayData(day: Days.FRIDAY.rawValue), DayData(day: Days.SATDAY.rawValue), DayData(day: Days.SUNDAY.rawValue)]
    let dateFormatter = DateFormatter()
        .then {
            $0.dateFormat = "a   hh : mm"
        }
    weak var delegate: (PresentAlertDelegate)?
    var isSelected: Bool = true
    
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
        addSubViews([guideLabel, onOffSwitch, dayStackView, timeButton, receiveAlarmLabel])
        
        self.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(136)
        }
        guideLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(3)
            make.left.equalToSuperview()
        }
        onOffSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(guideLabel)
            make.right.equalToSuperview()
        }
        dayStackView.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(20)
            make.left.equalTo(guideLabel)
            make.right.equalTo(onOffSwitch)
            make.height.equalTo(42)
        }
        timeButton.snp.makeConstraints { make in
            make.top.equalTo(dayStackView.snp.bottom).offset(8)
            make.left.equalTo(dayStackView)
            make.width.equalTo(136)
            make.height.equalTo(42)
        }
        receiveAlarmLabel.snp.makeConstraints { make in
            make.left.equalTo(timeButton.snp.right).offset(8)
            make.centerY.equalTo(timeButton)
        }
    }
    
    private func configUI() {
        timeSelectViewController.view = timeSelectPicker
    }
    
    /// 상황에 따라 버튼의 스타일을 업데이트 해줌
    private func updateStyleOf(_ button: UIButton, index: Int) {
        if dayList[index].isSelected {
            button.backgroundColor = .primary
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .gray01
            button.setTitleColor(.black, for: .normal)
        }
    }
    
    /// 요일 값이 배열에서 몇번째에 위치한 값인지 반환해주는 함수
    private func getIndexOf(_ element: String) -> Int? {
        // 비교를 위해 dayList에서 String 타입의 day만 가지고 있는 배열을 구성
        let dayStringList = dayList.map { dayData in
            dayData.day
        }
        // 해당 String 배열에서 element 값이 몇 번째 인덱스인지 검색
        return dayStringList.firstIndex(of: element)
    }
    
    // MARK: - @objc Functions
    
    /// 요일 버튼 클릭 시 실행
    /// dayList에서 해당 인덱스의 isSelected 값을 토글하고
    /// 버튼의 스타일을 바꿔줌
    @objc
    private func selectAlarmDay(_ sender: UIButton) {
        let selectedIndex = getIndexOf(sender.titleLabel?.text ?? "") ?? 0
        dayList[selectedIndex].isSelected.toggle()
        updateStyleOf(sender, index: selectedIndex)
        
        // TODO: - 서버에 값 전달 시 사용할 듯
//        if let day = Days(rawValue: dayList[selectedIndex].day) {
//            Logger.debugDescription(day)
//        }
    }
    
    /// 시간 설정 버튼 클릭 시 실행
    /// 시간을 선택할 수 있는 DatePicker가 액션 시트 형태로 present 된다
    @objc
    private func presentTimeAlert() {
        timeSelectAlert
            .setValue(timeSelectViewController, forKey: "contentViewController")
        delegate?.present(alert: timeSelectAlert)
    }
}
