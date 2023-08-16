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

/// 버튼의 상태를 나타내는 enum
enum ButtonState {
    case original
    case press
    case disabled
}

class RoundedDarkButton: UIButton {
    
    // MARK: - Properties
    
    var titleString = "" {
        didSet {
            self.setTitle(titleString, for: .normal)
        }
    }
    var buttonState: ButtonState = .disabled {
        didSet {
            updateButtonStyle(state: buttonState)
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
        self.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
    }
    private func configUI() {
        layer.cornerRadius = 20
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .pretendard(.semibold, ofSize: 16)
        updateButtonStyle(state: .disabled)
    }
    
    /// 버튼 state에 따라 버튼 스타일을 변경
    private func updateButtonStyle(state: ButtonState) {
        switch state {
        case .original:
            isEnabled = true
            backgroundColor = .gray06
        case .press:
            isEnabled = true
            backgroundColor = .black
        case .disabled:
            isEnabled = false
            backgroundColor = .gray02
        }
    }
}
