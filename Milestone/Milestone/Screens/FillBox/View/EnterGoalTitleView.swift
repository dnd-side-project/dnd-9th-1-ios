//
//  EnterGoalTitleView.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/15.
//

import UIKit

import SnapKit
import Then

// MARK: - 목표 제목 입력 뷰

class EnterGoalTitleView: UIView {
    
    // MARK: - Subviews
    
    var guideLabel = UILabel()
        .then {
            $0.text = "제목"
            $0.textAlignment = .left
            $0.font = .pretendard(.semibold, ofSize: 16)
            $0.textColor = .black
        }
    lazy var titleTextField = UITextField()
        .then {
            $0.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요!", attributes: [.foregroundColor: UIColor.gray02])
            $0.textAlignment = .left
            $0.font = .pretendard(.semibold, ofSize: 16)
            $0.textColor = .black
            $0.backgroundColor = .gray01
            $0.layer.cornerRadius = 10
            $0.setLeftPaddingPoints(16)
            $0.addTarget(self, action: #selector(updateNowNumOfCharaters), for: .editingChanged)
            $0.delegate = self
        }
    var limitGuideLabel = UILabel()
        .then {
            $0.text = "0/15"
            $0.textAlignment = .right
            $0.font = .pretendard(.regular, ofSize: 10)
            $0.textColor = .black
        }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        render()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func render() {
        addSubViews([guideLabel, titleTextField, limitGuideLabel])
        
        self.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(97)
        }
        guideLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(46)
        }
        limitGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(4)
            make.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - @objc Functions
    
    /// 현재 텍스트필드의 글자 수 업데이트
    @objc
    private func updateNowNumOfCharaters(_ textField: UITextField) {
        limitGuideLabel.text = "\(textField.text?.count ?? 0)/15"
    }
}

extension EnterGoalTitleView: UITextFieldDelegate {
    /// 텍스트 필드 15글자 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 15
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
}
