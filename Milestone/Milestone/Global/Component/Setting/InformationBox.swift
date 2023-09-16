//
//  InformationBox.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/25.
//

import UIKit

class InformationBox: UIView {
    
    var text: String! {
        didSet {
            configUI()
        }
    }

    let titleLabel = InformationLabel()
        .then {
            $0.isPrimary = true
        }
    
    let contentsLabel = InformationLabel()
        .then {
            $0.numberOfLines = 0
            $0.isPrimary = false
        }

    // MARK: Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        render()
        configUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        self.addSubViews([titleLabel, contentsLabel])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func configUI() {
        contentsLabel.text = text
        contentsLabel.setLineSpacing(lineHeightMultiple: 1.2)
    }
}
