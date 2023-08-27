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

class MoreViewController: BaseViewController, ViewModelBindableType {
    
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
            $0.iconImageView.image = ImageLiteral.imgModify
            $0.optionLabel.text = "수정하기"
            var tapModifyGesture = UITapGestureRecognizer(target: self, action: #selector(self.presentModifyGoalViewController))
            $0.addGestureRecognizer(tapModifyGesture)
        }
    lazy var removeOptionView = MoreOptionView()
        .then {
            $0.iconImageView.image = ImageLiteral.imgRemove
            $0.optionLabel.text = "삭제하기"
            var tapRemoveGesture = UITapGestureRecognizer(target: self, action: #selector(self.presentDeleteGoalViewController))
            $0.addGestureRecognizer(tapRemoveGesture)
        }
    
    // MARK: - Properties
    
    var viewModel: DetailParentViewModel!
    var isFromStorage = false
    let viewHeight = 173.0
    var dateFormatter = DateFormatter()
        .then {
            $0.dateFormat = "yyyy / MM / dd"
        }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromStorage { changeModifyToRestore() }
    }
    
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
    
    /// 수정하기 버튼을 복구하기 버튼으로 바꿔치기 -> 뷰와 제스처 함수 변경
    private func changeModifyToRestore() {
        modifyOptionView.optionLabel.text = "복구하기"
        modifyOptionView.iconImageView.image = ImageLiteral.imgRestore
        let tapRestoreGesture = UITapGestureRecognizer(target: self, action: #selector(self.presentRestoreGoalViewController))
        modifyOptionView.addGestureRecognizer(tapRestoreGesture)
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func presentModifyGoalViewController() {
        lazy var addParentGoalVC = AddParentGoalViewController()
            .then {
                $0.isModifyMode = true
                $0.viewModel = viewModel
                $0.viewModel.parentGoalId = viewModel.selectedParentGoal?.identity ?? 0
                $0.completeButton.titleString = "목표 수정 완료"
                $0.enterGoalDateView.isModifyMode = true
                $0.enterGoalTitleView.titleTextField.text = viewModel.selectedParentGoal?.title
                let startDate = changeDateFormat(viewModel.selectedParentGoal!.startDate)
                let endDate = changeDateFormat(viewModel.selectedParentGoal!.endDate)
                $0.enterGoalDateView.startDateButton.setTitle(startDate, for: .normal)
                $0.enterGoalDateView.endDateButton.setTitle(endDate, for: .normal)
                if let startDate = dateFormatter.date(from: startDate!),
                   let endDate = dateFormatter.date(from: endDate!) {
                    $0.enterGoalDateView.startDateToModify = startDate
                    $0.enterGoalDateView.endDateToModify = endDate
                    $0.enterGoalDateView.setDatePicker()
                }
                $0.enterGoalTitleView.updateNowNumOfCharaters()
            }
        dismiss(animated: true)
        self.presentingViewController?.presentCustomModal(addParentGoalVC, height: addParentGoalVC.viewHeight)
    }
   
    @objc
    private func presentDeleteGoalViewController() {
        Logger.debugDescription("삭제하기 클릭")
        let deleteGoalPopUp = DeleteGoalViewController()
            .then {
                $0.viewModel = viewModel
                $0.modalTransitionStyle = .crossDissolve
                $0.modalPresentationStyle = .overFullScreen
            }
        dismiss(animated: true)
        self.presentingViewController?.present(deleteGoalPopUp, animated: true)
    }
    
    @objc
    private func presentRestoreGoalViewController() {
        Logger.debugDescription("복구하기 클릭")
        let restoreGoalPopUp = RestoreGoalViewController()
            .then {
                $0.viewModel = viewModel
                $0.modalTransitionStyle = .crossDissolve
                $0.modalPresentationStyle = .overFullScreen
            }
        dismiss(animated: true)
        self.presentingViewController?.present(restoreGoalPopUp, animated: true)
    }
}
