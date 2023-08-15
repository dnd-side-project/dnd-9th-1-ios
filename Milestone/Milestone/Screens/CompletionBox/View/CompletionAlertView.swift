//
//  CompletionAlertView.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/15.
//

import UIKit

class CompletionAlertView: UIView {
    
    // MARK: - Subviews
    private let alertImageView = UIImageView()
        .then {
            $0.image = #imageLiteral(resourceName: "alert")
        }
    
    private let label = UILabel()
        .then {
            $0.font = UIFont.pretendard(.semibold, ofSize: 14)
            let stringValue = "총 1개의 목표 회고를 작성할 수 있어요!"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
            attributedString.setColorForText(textForAttribute: "총 1개의 목표 회고", withColor: .pointPurple)
            attributedString.setColorForText(textForAttribute: "를 작성할 수 있어요!", withColor: .black)
            
            $0.attributedText = attributedString
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
        addSubViews([alertImageView, label])
        
        alertImageView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(24)
            make.centerY.equalTo(snp.centerY)
            make.height.width.equalTo(20)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(alertImageView.snp.trailing).offset(8)
            make.centerY.equalTo(snp.centerY)
        }
    }
    
    private func configUI() {
        self.backgroundColor = .white
    }

}
