//
//  RoundedDarkButton.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/15.
//

import UIKit

import SnapKit
import Then

// MARK: - 모달뷰 하단에 있는 모서리가 둥근 버튼

class RoundedButton: UIButton {
    
    // MARK: - Properties
    
    var titleString = "" {
        didSet {
            self.setTitle(titleString, for: .normal)
        }
    }
    var buttonState: ButtonState = .disabled {
        didSet {
            updateButtonStyle(state: buttonState, style: buttonComponentStyle)
        }
    }
    var buttonComponentStyle: ButtonComponentStyle = .primary_l {
        didSet {
            updateButtonStyle(state: buttonState, style: buttonComponentStyle)
        }
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
//        self.snp.makeConstraints { make in
//            make.height.equalTo(54)
//        }
    }
    private func configUI() {
        layer.cornerRadius = 20
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .pretendard(.semibold, ofSize: 16)
        updateButtonStyle(state: .disabled, style: buttonComponentStyle)
    }
    
    /// 버튼 state에 따라 버튼 스타일을 변경
    private func updateButtonStyle(state: ButtonState, style: ButtonComponentStyle) {
        switch style {
        case .primary_l:
            switch state {
            case .original:
                isEnabled = true
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .gray06
            case .press:
                isEnabled = true
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .black
            case .disabled:
                isEnabled = false
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .gray02
            }
        case .secondary_l:
            switch state {
            case .original:
                isEnabled = true
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .primary
            case .press:
                isEnabled = true
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .init(hex: "#2A6DC6")
            case .disabled:
                isEnabled = false
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .init(hex: "#ADBED6")
            }
        case .secondary_m:
            switch state {
            case .original:
                isEnabled = true
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .secondary03
                setTitleColor(.primary, for: .normal)
            case .press:
                isEnabled = true
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .secondary02
                setTitleColor(.primary, for: .normal)
            case .disabled:
                isEnabled = false
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .secondary03
                setTitleColor(.gray02, for: .normal)
            }
        case .secondary_m_line:
            switch state {
            case .original:
                isEnabled = true
                backgroundColor = .white
                layer.borderColor = UIColor.secondary01.cgColor
                layer.borderWidth = 1
                setTitleColor(.primary, for: .normal)
            case .press:
                isEnabled = true
                backgroundColor = .secondary01
                layer.borderColor = UIColor.secondary01.cgColor
                layer.borderWidth = 1
                setTitleColor(.init(hex: "#E9F4FF"), for: .normal)
            case .disabled:
                isEnabled = false
                backgroundColor = .white
                layer.borderColor = UIColor.gray02.cgColor
                layer.borderWidth = 1
                setTitleColor(.gray02, for: .disabled)
            }
        case .secondary_m_gray:
            switch state {
            case .original:
                isEnabled = true
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .gray01
                setTitleColor(.gray04, for: .normal)
            case .press:
                isEnabled = true
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .gray02
                setTitleColor(.gray04, for: .normal)
            case .disabled:
                isEnabled = false
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .white
                setTitleColor(.gray02, for: .disabled)
            }
        case .secondary_s:
            switch state {
            case .original:
                layer.borderColor = UIColor.clear.cgColor
                isEnabled = true
                backgroundColor = .secondary03
                setTitleColor(.primary, for: .normal)
            case .press:
                isEnabled = true
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .secondary02
                setTitleColor(.primary, for: .normal)
            case .disabled:
                isEnabled = false
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .secondary02
                setTitleColor(.gray02, for: .disabled)
            }
        case .secondary_s_gray:
            switch state {
            case .original:
                isEnabled = true
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .gray01
                setTitleColor(.gray04, for: .normal)
            case .press:
                isEnabled = true
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .gray02
                setTitleColor(.gray04, for: .normal)
            case .disabled:
                isEnabled = false
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = .white
                setTitleColor(.gray02, for: .disabled)
            }
        }
    }
}

// MARK: - UpdateButtonStateDelegate

extension RoundedButton: UpdateButtonStateDelegate {
    func updateButtonState(_ state: ButtonState) {
        self.buttonState = state
    }
}
