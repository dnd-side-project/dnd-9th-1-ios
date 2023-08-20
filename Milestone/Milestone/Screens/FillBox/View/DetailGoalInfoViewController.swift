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
            $0.removeButton.addTarget(self, action: #selector(replacePopUpViewToRemove), for: .touchUpInside)
            $0.modifyButton.addTarget(self, action: #selector(replacePopUpViewToModify), for: .touchUpInside)
        }
    
    // MARK: - Properties
    
    weak var delegate: (PresentDelegate)?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGoalInfo()
    }
    
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
    
    /// TEMP
    private func setGoalInfo() {
        infoView.stoneImageView.image = ImageLiteral.imgDetailStoneVer1
        infoView.titleLabel.text = "테스트~"
        infoView.startDateLabel.text = "2033.02.02 시작"
    }
    
    private func dismissViewController() {
        self.dismiss(animated: true)
    }
    
    // MARK: - @objc Functions
    
    /// 팝업 뷰 교체
    /// 세부 목표 정보 팝업 뷰 dismiss하고
    /// 목표 삭제 팝업 뷰를 present한다
    @objc
    private func replacePopUpViewToRemove() {
        dismissViewController()
        delegate?.present(DeleteGoalViewController())
        // TODO: - 삭제 API 연동
    }
    
    /// 팝업 뷰 교체
    /// 세부 목표 정보 팝업 뷰 dismiss하고
    /// 목표 수정 팝업 뷰를 present한다
    @objc
    private func replacePopUpViewToModify() {
        dismissViewController()
        lazy var addParentGoalVC = AddParentGoalViewController()
            .then {
                $0.completeButton.titleString = "목표 수정 완료"
                $0.enterGoalTitleView.titleTextField.text = "토익 900점 넘기기"
                $0.enterGoalTitleView.updateNowNumOfCharaters()
            }
        self.presentingViewController?.presentCustomModal(addParentGoalVC, height: addParentGoalVC.viewHeight)
        // TODO: - 수정 API 연동
    }
}
