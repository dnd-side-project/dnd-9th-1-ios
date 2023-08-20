//
//  StorageBoxViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/11.
//

import UIKit

import SnapKit
import Then

// MARK: - 보관함 화면

class StorageBoxViewController: BaseViewController {
    
    // MARK: - Subviews
    
    let emptyStorageImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgEmptyStorage
        }
    lazy var firstEmptyGuideLabel = UILabel()
        .then {
            $0.text = "기간 내에 완료하지 못한\n목표들이 보관됩니다."
            $0.numberOfLines = 2
            $0.setLineSpacing(lineHeightMultiple: 1.2)
            $0.textColor = .gray02
            $0.font = .pretendard(.semibold, ofSize: 18)
            $0.textAlignment = .center
        }
    let secondEmptyGuideLabel = UILabel()
        .then {
            $0.text = "언제든지 다시 시작할 수 있어요!"
            $0.textColor = .gray02
            $0.font = .pretendard(.semibold, ofSize: 18)
            $0.textAlignment = .center
        }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([emptyStorageImageView, firstEmptyGuideLabel, secondEmptyGuideLabel])
        emptyStorageImageView.snp.makeConstraints { make in
            make.width.height.equalTo(250)
            make.top.equalToSuperview().inset(127)
            make.centerX.equalToSuperview()
        }
        firstEmptyGuideLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyStorageImageView.snp.bottom).offset(24)
        }
        secondEmptyGuideLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(firstEmptyGuideLabel.snp.bottom).offset(14)
        }
    }
}
