//
//  ToastView.swift
//  Milestone
//
//  Created by 박경준 on 2023/09/27.
//

import UIKit

class ToastView: UIView {
    
    // MARK: - Subviews
    
    let warningImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgWarning
        }
    
    let label = UILabel()
        .then {
            $0.font = .pretendard(.semibold, ofSize: 16)
            $0.textColor = .white
        }
    
    // MARK: - Properties
    
    lazy var text: String = "" {
        didSet {
            label.text = text
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
    
    func render() {
        [warningImageView, label].forEach { self.addSubview($0) }
        
        warningImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.snp.leading).offset(16)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(warningImageView.snp.trailing).offset(16)
            make.centerY.equalTo(warningImageView)
        }
    }
    
    func configUI() {
        self.layer.cornerRadius = 10
        self.backgroundColor = .gray05
    }
}
