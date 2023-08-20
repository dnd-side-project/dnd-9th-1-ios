//
//  MoreViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/14.
//

import UIKit

import SnapKit
import Then

// MARK: - 상위 목표 상세 더보기 화면

class MoreViewController: BaseViewController {
    
    // MARK: - SubViews
    
    let containerView = UIView()
        .then {
            $0.backgroundColor = .white
            $0.layer.masksToBounds = true
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.cornerRadius = 20
        }
    let barView = UIView()
        .then {
            $0.backgroundColor = .gray02
            $0.layer.cornerRadius = 5 / 2
        }
    lazy var modifyOptionView = MoreOptionView()
        .then {
            $0.optionLabel.text = "수정하기"
            var tapModifyGesture = UITapGestureRecognizer(target: self, action: #selector(self.presentModifyGoalViewController))
            $0.addGestureRecognizer(tapModifyGesture)
        }
    lazy var removeOptionView = MoreOptionView()
        .then {
            $0.optionLabel.text = "삭제하기"
            var tapRemoveGesture = UITapGestureRecognizer(target: self, action: #selector(self.presentDeleteGoalViewController))
            $0.addGestureRecognizer(tapRemoveGesture)
        }
    // MARK: - Properties
    
    let viewHeight = 173.0
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([containerView])
        containerView.addSubViews([barView, modifyOptionView, removeOptionView])
        
        containerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(viewHeight)
        }
        barView.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(64)
            make.height.equalTo(5)
        }
        modifyOptionView.snp.makeConstraints { make in
            make.top.equalTo(barView.snp.bottom).offset(32)
            make.left.equalToSuperview().inset(24)
        }
        removeOptionView.snp.makeConstraints { make in
            make.top.equalTo(modifyOptionView.snp.bottom).offset(32)
            make.left.equalTo(modifyOptionView)
        }
    }

    override func configUI() {
        containerView.makeShadow(color: .init(hex: "#464646", alpha: 0.2), alpha: 1, x: 0, y: -10, blur: 20, spread: 0)
    }
    
    // MARK: - @objc Functions

    @objc
    private func presentModifyGoalViewController() {
        let addParentGoalVC = AddParentGoalViewController()
            .then {
                $0.modalTransitionStyle = .coverVertical
                $0.modalPresentationStyle = .pageSheet
            }
        
        guard let sheet = addParentGoalVC.sheetPresentationController else { return }
        let fraction = UISheetPresentationController.Detent.custom { _ in addParentGoalVC.viewHeight }
        sheet.detents = [fraction]
        present(addParentGoalVC, animated: true)
        
        addParentGoalVC.completeButton.titleString = "목표 수정 완료"
        addParentGoalVC.enterGoalTitleView.titleTextField.text = "토익 900점 넘기기"
        addParentGoalVC.enterGoalTitleView.updateNowNumOfCharaters()
    }

    @objc
    private func presentDeleteGoalViewController() {
        Logger.debugDescription("삭제하기 클릭")
        let deleteGoalPopUp = DeleteGoalViewController()
            .then {
                $0.modalTransitionStyle = .crossDissolve
                $0.modalPresentationStyle = .overFullScreen
            }
        present(deleteGoalPopUp, animated: true)
    }
}
