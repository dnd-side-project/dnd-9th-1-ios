//
//  EnterGoalAlarmView.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/17.
//

import UIKit

import SnapKit
import Then

struct DayData: Equatable {
    var day: String
    var isSelected: Bool = false
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
            $0.addTarget(self, action: #selector(toggleAlarmSwitch), for: .valueChanged)
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
                        if i.day == DayStyle.MONDAY.rawValue {
                            selectAlarmDay($0)
                        }
                    }
                $0.addArrangedSubview(dayButton)
            }
        }
    lazy var timeButton = UIButton()
        .then {
            $0.backgroundColor = .gray01
            $0.setTitle("\(selectedAmOrPm)   \(selectedHour) : \(selectedMin)", for: .normal)
            $0.layer.cornerRadius = 10
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .pretendard(.semibold, ofSize: 16)
            $0.addTarget(self, action: #selector(presentTimePickerView), for: .touchUpInside)
        }
    lazy var receiveAlarmLabel = UILabel()
        .then {
            $0.text = "에 알람을 받을게요!"
            $0.textAlignment = .left
            $0.font = .pretendard(.semibold, ofSize: 14)
            $0.textColor = .black
        }
    lazy var timePickerView = UIPickerView()
        .then {
            $0.delegate = self
            $0.dataSource = self
            $0.selectRow(1, inComponent: 0, animated: false) // 피커뷰가 '오후'를 가리키고 있도록 설정
        }
    lazy var timePickerAlert = UIAlertController(title: nil, message: "시간을 선택해주세요", preferredStyle: .actionSheet)
        .then {
            $0.addAction(timePickerAction)
        }
    lazy var timePickerAction = UIAlertAction(title: "완료", style: .default) { [self] _ in
        timeButton.setTitle("\(selectedAmOrPm)   \(selectedHour) : \(selectedMin)", for: .normal)
        Logger.debugDescription("최종 선택된 요일 : \(getSelectedDay())")
    }
    let timePickerViewController = UIViewController()
    
    // MARK: - Properties
    
    weak var delegate: (PresentDelegate)?
    private var timePickerData = [["오전", "오후"], ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"], ["00", "30"]]
    private var dayList = [DayData(day: DayStyle.MONDAY.rawValue), DayData(day: DayStyle.TUESDAY.rawValue), DayData(day: DayStyle.WEDNESDAY.rawValue), DayData(day: DayStyle.THURSDAY.rawValue), DayData(day: DayStyle.FRIDAY.rawValue), DayData(day: DayStyle.SATURDAY.rawValue), DayData(day: DayStyle.SUNDAY.rawValue)]
    var selectedAmOrPm = "오후"
    var selectedHour = "01"
    var selectedMin = "00"
    
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
        timePickerViewController.view = timePickerView
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
    
    /// 최종 선택된 요일 배열을 반환
    func getSelectedDay() -> [String] {
        return dayList
            .filter { day in // 선택된 값들만 필터링 하고
                day.isSelected
            }
            .map { day in // 그 중 String만 가지고 배열을 구성
                DayStyle(rawValue: day.day)!.caseString // MONDAY
            }
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func toggleAlarmSwitch() {
        [dayStackView, timeButton, receiveAlarmLabel].forEach { $0.isHidden = !onOffSwitch.isOn }
    }
    
    /// 요일 버튼 클릭 시 실행
    /// dayList에서 해당 인덱스의 isSelected 값을 토글하고
    /// 버튼의 스타일을 바꿔줌
    @objc
    private func selectAlarmDay(_ sender: UIButton) {
        let selectedIndex = getIndexOf(sender.titleLabel?.text ?? "") ?? 0
        dayList[selectedIndex].isSelected.toggle()
        updateStyleOf(sender, index: selectedIndex)
    }
    
    /// 시간 선택할 수 있는 피커뷰가 들어있는 액션시트를 present
    @objc
    private func presentTimePickerView() {
        timePickerAlert
            .setValue(timePickerViewController, forKey: "contentViewController")
        delegate?.present(alert: timePickerAlert)
    }
}

extension EnterGoalAlarmView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        timePickerData[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        timePickerData[component][row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedAmOrPm = timePickerData[component][row] // 오전, 오후
        case 1:
            selectedHour = timePickerData[component][row]
        case 2:
            selectedMin = timePickerData[component][row]
        default:
            return
        }
    }
}
