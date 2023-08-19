//
//  DetailGoalInfoViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/15.
//

import UIKit

import RxCocoa
import RxSwift
import Then

// MARK: - 세부 목표 정보 팝업뷰

class DetailGoalInfoViewController: BaseViewController {
    
    // MARK: - SubViews
    
    let dimmedViewTap = UITapGestureRecognizer()
    lazy var dimmedView = UIView()
        .then {
            $0.backgroundColor = .black.withAlphaComponent(0.3)
            $0.addGestureRecognizer(dimmedViewTap)
        }
    lazy var infoView = DetailGoalInfoView()
        .then {
            $0.titleLabel.text = "기출문제다시한번풀고정리해보기"
            $0.stoneImageView.image = ImageLiteral.imgDetailStoneVer1 // TEMP
            $0.removeButton.addTarget(self, action: #selector(replacePopUpView), for: .touchUpInside)
        }
    
    // MARK: - Properties
    
    weak var delegate: (PresentDelegate)?
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([dimmedView, infoView])
        
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        infoView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func bind() {
        infoView.xButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        dimmedViewTap.rx.event
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func dismissViewController() {
        self.dismiss(animated: true)
    }
    
    // MARK: - @objc Functions
    
    /// 팝업 뷰 교체
    /// 세부 목표 정보 팝업 뷰 dismiss하고
    /// 목표 삭제 팝업 뷰를 present한다
    @objc
    private func replacePopUpView() {
        dismissViewController()
        delegate?.present(DeleteGoalViewController())
        // TODO: - 삭제 API 연동
    }
}
