//
//  LowerGoalInfoViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/15.
//

import UIKit

import RxCocoa
import RxSwift
import Then

// MARK: - 하위 목표 정보 팝업뷰

class LowerGoalInfoViewController: BaseViewController, ViewModelBindableType {
    
    // MARK: - SubViews
    
    let dimmedViewTap = UITapGestureRecognizer()
    lazy var dimmedView = UIView()
        .then {
            $0.backgroundColor = .black.withAlphaComponent(0.3)
            $0.addGestureRecognizer(dimmedViewTap)
        }
    lazy var infoView = LowerGoalInfoView()
        .then {
            $0.titleLabel.text = ""
            $0.stoneImageView.image = ImageLiteral.imgDetailStoneVer1 // TEMP
            $0.removeButton.addTarget(self, action: #selector(replacePopUpViewToRemove), for: .touchUpInside)
            $0.modifyButton.addTarget(self, action: #selector(replacePopUpViewToModify), for: .touchUpInside)
        }
    
    // MARK: - Properties
    
    var viewModel: DetailUpperViewModel!
    var delegate: DetailUpperViewController!
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.retrieveLowerGoalInfo()
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
    
    override func bindUI() {
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
    
    func bindViewModel() {
        viewModel.thisLowerGoal
            .subscribe(onNext: { info in
                self.infoView.titleLabel.text = info.title
                let alarmDaysString = info.alarmDays.map {
                    DayForResStyle(rawValue: $0)?.caseString ?? ""
                }.joined(separator: ",") // ["MONDAY", "TUESDAY", "WEDNESDAY"]를 월,화,수" 형태로 변경
                self.infoView.alarmInfoLabel.text = info.alarmEnabled ? "\(alarmDaysString) \(info.alarmTime)" : "알림 중단"
            })
            .disposed(by: disposeBag)
    }
    
    private func dismissViewController() {
        self.dismiss(animated: true)
    }
    
    // MARK: - @objc Functions
    
    /// 팝업 뷰 교체
    /// 하위 목표 정보 팝업 뷰 dismiss하고
    /// 목표 삭제 팝업 뷰를 present한다
    @objc
    private func replacePopUpViewToRemove() {
        dismissViewController()
        let deleteGoalVC = DeleteGoalViewController()
            .then {
                $0.viewModel = viewModel
                $0.delegate = delegate
                $0.fromUpperGoal = false
                $0.modalPresentationStyle = .overFullScreen
                $0.modalTransitionStyle = .crossDissolve
            }
        self.presentingViewController?.present(deleteGoalVC, animated: true)
    }
    
    /// 팝업 뷰 교체
    /// 하위 목표 정보 팝업 뷰 dismiss하고
    /// 목표 수정 팝업 뷰를 present한다
    @objc
    private func replacePopUpViewToModify() {
        dismissViewController()
        lazy var addLowerGoalVC = AddLowerGoalViewController()
            .then {
                $0.viewModel = viewModel
                $0.delegate = delegate
                $0.isModifyMode = true
                $0.enterGoalTitleView.updateNowNumOfCharaters()
            }
        self.presentingViewController?.presentCustomModal(addLowerGoalVC, height: addLowerGoalVC.viewHeight)
    }
}
