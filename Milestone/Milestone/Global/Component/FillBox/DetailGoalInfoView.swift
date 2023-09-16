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
            $0.textAlignment = .left
            $0.font = .pretendard(.semibold, ofSize: 16)
            $0.textColor = .black
        }
    let alarmImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgAlarm
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
        addSubViews([stoneImageView, titleLabel, alarmImageView, alarmInfoLabel, xButton, removeButton, modifyButton])
        
        self.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(230)
        }
        stoneImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(48)
            make.left.equalToSuperview().inset(17)
            make.width.height.equalTo(81)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(stoneImageView).offset(16.5)
            make.left.equalTo(stoneImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(17)
        }
        alarmImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(13.17)
            make.left.equalTo(stoneImageView.snp.right).offset(18.67)
            make.width.height.equalTo(11)
        }
        alarmInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(alarmImageView)
            make.left.equalTo(alarmImageView.snp.right).offset(4.67)
        }
        xButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        removeButton.snp.makeConstraints { make in
            make.top.equalTo(stoneImageView.snp.bottom).offset(24)
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
}
