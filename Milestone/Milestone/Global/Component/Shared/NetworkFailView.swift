//
//  NetworkFailView.swift
//  Milestone
//
//  Created by 서은수 on 2023/09/27.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

// MARK: - 네트워크 접속 실패 뷰

class NetworkFailView: UIView {
    
    // MARK: - Subviews
    
    var failImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgNetworkFail
        }
    var guideLabel = UILabel()
        .then {
            $0.numberOfLines = 0
            $0.text = "네트워크에 접속할 수 없습니다.\n네트워크 연결 상태를 확인해주세요!"
            $0.textAlignment = .center
            $0.font = .pretendard(.semibold, ofSize: 18)
            $0.textColor = .gray02
        }
    lazy var retryButton = UIButton()
        .then {
            $0.setTitle("재시도", for: .normal)
            $0.titleLabel?.font = .pretendard(.semibold, ofSize: 16)
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .primary
            $0.addTarget(self, action: #selector(retryConnection), for: .touchUpInside)
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
        addSubViews([failImageView, guideLabel, retryButton])
        
        self.snp.makeConstraints { make in
            make.width.equalTo(390)
            make.height.equalTo(401)
        }
        failImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(250)
        }
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(failImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(40)
            make.centerX.bottom.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(46)
        }
    }
    
    // MARK: - @objc Functions
    
    /// 네트워크 연결 재시도
    @objc
    private func retryConnection() {
        Logger.debugDescription("Click")
    }
}
