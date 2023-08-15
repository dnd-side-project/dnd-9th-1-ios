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

class RoundedDarkButton: UIButton {
    
    // MARK: - Properties
    
    var titleString = "" {
        didSet {
            self.setTitle(titleString, for: .normal)
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
        backgroundColor = .gray06
        layer.cornerRadius = 20
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .pretendard(.semibold, ofSize: 16)
    }
}
