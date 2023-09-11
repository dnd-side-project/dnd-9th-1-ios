//
//  LoadingView.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/23.
//

import SnapKit
import Then
import UIKit

class LoadingView: UIView {
    // MARK: - Private Properties
    
    private var indicator = UIActivityIndicatorView(frame: CGRect(x: 0,
                                                                  y: 0, width: 50,
                                                                  height: 50))
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        configureView()
//        layoutView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        configureView()
//        layoutView()
    }
}

// MARK: - Configure

extension LoadingView {
    private func configureView() {
//        backgroundColor = .black.withAlphaComponent(0.6)
        addSubview(indicator)
    }
}

// MARK: - Layout

extension LoadingView {
    private func layoutView() {
        indicator.snp.makeConstraints { make in
            make.top.equalTo(UIScreen.main.bounds.height / 3)
            make.centerX.equalToSuperview()
        }
        indicator.startAnimating()
    }
}
