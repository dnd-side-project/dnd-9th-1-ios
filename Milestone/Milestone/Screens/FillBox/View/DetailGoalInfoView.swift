//
//  DetailGoalInfoView.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/15.
//

import UIKit

import SnapKit
import Then

// MARK: - 세부 목표 정보 뷰

class DetailGoalInfoView: UIView {
    
    // MARK: - Subviews
    
    var stoneImageView = UIImageView()
    var titleLabel = UILabel()
        .then {
            $0.text = "기출 문제 다시 풀기"
            $0.textAlignment = .left
            $0.font = .pretendard(.semibold, ofSize: 20)
            $0.textColor = .black
        }
    var startDateLabel = UILabel()
        .then {
            $0.text = "2023.11.23 시작"
            $0.textAlignment = .left
            $0.font = .pretendard(.regular, ofSize: 16)
            $0.textColor = .gray03
        }
    let alarmImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgAlarm
            $0.layer.cornerRadius = 24 / 2
        }
    var alarmInfoLabel = UILabel()
        .then {
            $0.text = "월 오전 10:00"
            $0.textAlignment = .left
            $0.font = .pretendard(.regular, ofSize: 14)
            $0.textColor = .gray03
        }
    let xButton = UIButton()
        .then {
            $0.setImage(ImageLiteral.imgX, for: .normal)
            $0.configuration = .plain()
        }
    lazy var removeButton = UIButton()
        .then {
            $0.backgroundColor = .gray01
            $0.layer.cornerRadius = 20
            // 버튼 타이틀에 적용할 폰트 설정
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.pretendard(.semibold, ofSize: 16),
                .foregroundColor: UIColor.gray04
            ]
            $0.setAttributedTitle(NSAttributedString(string: "삭제하기", attributes: attributes), for: .normal)
//            $0.addTarget(self, action: #selector(removeDetailGoal), for: .touchUpInside)
        }
    lazy var modifyButton = UIButton()
        .then {
            $0.backgroundColor = .secondary03
            $0.layer.cornerRadius = 20
            // 버튼 타이틀에 적용할 폰트 설정
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.pretendard(.semibold, ofSize: 16),
                .foregroundColor: UIColor.primary
            ]
            $0.setAttributedTitle(NSAttributedString(string: "수정하기", attributes: attributes), for: .normal)
            $0.addTarget(self, action: #selector(modifyDetailGoal), for: .touchUpInside)
        }
    
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
        addSubViews([stoneImageView, titleLabel, startDateLabel, alarmImageView, alarmInfoLabel, xButton, removeButton, modifyButton])
        
        self.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(230)
        }
        stoneImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(35)
            make.width.height.equalTo(81)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.left.equalTo(stoneImageView.snp.right).offset(16)
            make.right.equalToSuperview()
        }
        startDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview()
        }
        alarmImageView.snp.makeConstraints { make in
            make.top.equalTo(startDateLabel.snp.bottom).offset(21.17)
            make.left.equalTo(startDateLabel).offset(2.67)
            make.height.equalTo(11)
        }
        alarmInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(alarmImageView)
            make.left.equalTo(alarmImageView.snp.right).offset(4.67)
        }
        xButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(24)
            make.width.height.equalTo(24)
        }
        removeButton.snp.makeConstraints { make in
            make.top.equalTo(stoneImageView.snp.bottom).offset(21)
            make.left.equalToSuperview().inset(43)
            make.width.equalTo(120)
            make.height.equalTo(54)
        }
        modifyButton.snp.makeConstraints { make in
            make.centerY.equalTo(removeButton)
            make.left.equalTo(removeButton.snp.right).offset(16)
            make.width.equalTo(120)
            make.height.equalTo(54)
        }
    }
    
    private func configUI() {
        backgroundColor = .white
        layer.cornerRadius = 20
    }
//
//    @objc
//    func removeDetailGoal() {
//        // TODO: - 세부 목표 삭제하기 모달 연결
//        Logger.debugDescription("removeDetailGoal")
//    }
//
    @objc
    func modifyDetailGoal() {
        // TODO: - 세부 목표 수정하기 모달 연결
        Logger.debugDescription("modifyDetailGoal")
    }
}
