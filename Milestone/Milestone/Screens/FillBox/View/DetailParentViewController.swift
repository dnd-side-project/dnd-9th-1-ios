//
//  DetailParentViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/11.
//

import UIKit

import SnapKit
import Then

// MARK: - 상위 목표 상세 보기 화면

class DetailParentViewController: BaseViewController {
    
    // MARK: - Subviews
    
    lazy var leftBarButton = UIBarButtonItem()
        .then {
            $0.image = UIImage(systemName: "chevron.left")
            $0.style = .plain
            $0.tintColor = .gray05
            $0.target = self
            $0.action = #selector(pop)
        }
    lazy var rightBarButton = UIBarButtonItem()
        .then {
            $0.image = UIImage(systemName: "ellipsis")
            $0.style = .plain
            $0.tintColor = .gray05
            $0.target = self
            $0.action = #selector(pop) // TODO: - 나중에 바꿔야 함
        }
    let goalTitleLabel = UILabel()
        .then {
            $0.text = "토익 900점 넘기기"
            $0.textColor = .black
            $0.font = .pretendard(.semibold, ofSize: 24)
        }
    
    let dDayLabel = UILabel()
        .then {
            $0.text = "D - 183"
            $0.textColor = .gray01
            $0.font = .pretendard(.semibold, ofSize: 12)
            $0.backgroundColor = .pointPurple
            $0.textAlignment = .center
            $0.layer.cornerRadius = 24 / 2
            $0.clipsToBounds = true
        }
    
    let termLabel = UILabel()
        .then {
            $0.text = "2023.09.08 - 2023.12.02"
            $0.font = .pretendard(.regular, ofSize: 12)
            $0.textColor = .gray03
        }
    
    // MARK: - Properties
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([goalTitleLabel, dDayLabel, termLabel])
        
        goalTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
        }
        dDayLabel.snp.makeConstraints { make in
            make.top.equalTo(goalTitleLabel.snp.bottom).offset(12)
            make.left.equalTo(goalTitleLabel)
            make.width.equalTo(58)
            make.height.equalTo(24)
        }
        termLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dDayLabel)
            make.left.equalTo(dDayLabel.snp.right).offset(8)
        }
    }
    
    override func configUI() {
        view.backgroundColor = .gray01
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
}

#if canImport(SwiftUI) && (DEBUG)
import SwiftUI

struct DetailParentViewControllerRepresentable: UIViewControllerRepresentable {
    
    let viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct DetailParentViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        DetailParentViewControllerRepresentable(viewController: UINavigationController(rootViewController: DetailParentViewController()))
    }
}
#endif
