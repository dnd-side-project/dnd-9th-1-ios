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

class DetailGoalInfoViewController: BaseViewController, ViewModelBindableType {
    
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
            $0.removeButton.addTarget(self, action: #selector(replacePopUpViewToRemove), for: .touchUpInside)
            $0.modifyButton.addTarget(self, action: #selector(replacePopUpViewToModify), for: .touchUpInside)
        }
    
    // MARK: - Properties
    
    var viewModel: DetailParentViewModel!
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.retrieveDetailGoalInfo()
    }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([dimmedView, infoView, networkErrorToastView])
        
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        infoView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        networkErrorToastView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-50)
            make.height.equalTo(52)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
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
        viewModel.thisDetailGoal
            .subscribe(onNext: { info in
                self.infoView.titleLabel.text = info.title
                let alarmDaysString = info.alarmDays.map {
                    DayForResStyle(rawValue: $0)?.caseString ?? ""
                }.joined(separator: ",") // ["MONDAY", "TUESDAY", "WEDNESDAY"]를 월,화,수" 형태로 변경
                self.infoView.alarmInfoLabel.text = info.alarmEnabled ? "\(alarmDaysString) \(info.alarmTime)" : "알림 중단"
            })
            .disposed(by: disposeBag)
        
        networkMonitor.isConnected
            .subscribe(onNext: { [self] isConnected in
                DispatchQueue.main.async {
                    // 연결 끊겼으면 토스트 애니메이션
                    if !isConnected {
                        UIView.animate(withDuration: 0.2, delay: 0.5) {
                            self.networkErrorToastView.alpha = 1
                            self.networkErrorToastView.frame = CGRect(origin: CGPoint(x: self.networkErrorToastView.frame.origin.x, y: self.networkErrorToastView.frame.origin.y + 50), size: self.networkErrorToastView.frame.size)
                        } completion: { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                UIView.animate(withDuration: 0.2) {
                                    self.networkErrorToastView.alpha = 0
                                    self.networkErrorToastView.frame = CGRect(origin: CGPoint(x: self.networkErrorToastView.frame.origin.x, y: self.networkErrorToastView.frame.origin.y - 50), size: self.networkErrorToastView.frame.size)
                                }
                            }
                        }
                    }
                }
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
    private func replacePopUpViewToRemove() {
        dismissViewController()
        let deleteGoalVC = DeleteGoalViewController()
            .then {
                $0.viewModel = viewModel
                $0.fromParentGoal = false
                $0.modalPresentationStyle = .overFullScreen
                $0.modalTransitionStyle = .crossDissolve
            }
        self.presentingViewController?.present(deleteGoalVC, animated: true)
    }
    
    /// 팝업 뷰 교체
    /// 세부 목표 정보 팝업 뷰 dismiss하고
    /// 목표 수정 팝업 뷰를 present한다
    @objc
    private func replacePopUpViewToModify() {
        dismissViewController()
        lazy var addDetailGoalVC = AddDetailGoalViewController()
            .then {
                $0.viewModel = viewModel
                $0.isModifyMode = true
                $0.enterGoalTitleView.updateNowNumOfCharaters()
            }
        self.presentingViewController?.presentCustomModal(addDetailGoalVC, height: addDetailGoalVC.viewHeight)
    }
}
