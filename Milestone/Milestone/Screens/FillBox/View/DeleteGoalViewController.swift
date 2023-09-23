//
//  DeleteGoalViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/19.
//

import UIKit

import SnapKit
import Then

// MARK: - 목표 삭제 팝업 뷰 (상위, 하위 목표 동일하게 사용)

class DeleteGoalViewController: BaseViewController, ViewModelBindableType {
    
    // MARK: - Subviews
    
    lazy var askPopUpView = AskOneOfTwoView()
        .then {
            $0.askLabel.text = "정말 삭제 하시겠어요?"
            $0.guideLabel.text = "삭제된 목표는 되돌릴 수 없어요 🥺"
            $0.yesButton.setTitle("삭제할게요", for: .normal)
            $0.yesButton.buttonComponentStyle = .secondary_m_gray
            $0.yesButton.addTarget(self, action: #selector(deleteGoal), for: .touchUpInside)
            $0.noButton.setTitle("지금 안할래요", for: .normal)
            $0.noButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        }
    
    // MARK: - Properties
    
    var viewModel: DetailParentViewModel!
    var fromParentGoal = true // 상위 목표 삭제인지 하위 목표 삭제인지
    var delegate: UpdateDetailGoalListDelegate?
    
    // MARK: - Functions
    
    override func render() {
        view.addSubView(askPopUpView)
        
        askPopUpView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    override func configUI() {
        view.backgroundColor = .init(hex: "#000000", alpha: 0.3)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first, touch.view == view {
            dismissViewController()
        }
    }
    
    /// 삭제 팝업 dismiss 하고 detailParentVC도 pop 시켜서 채움함 메인 화면으로 전환
    private func goToFillBox() {
        self.dismiss(animated: true)
        self.viewModel?.popDetailParentVC.accept(true)
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func dismissViewController() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func deleteGoal() {
        askPopUpView.yesButton.updateButtonState(.press)
        
        // 상위 목표 삭제 API 호출
        if fromParentGoal {
            viewModel.deleteParentGoal()
            goToFillBox()
        } else {
            viewModel.deleteDetailGoal()
            
            if viewModel.detailGoalList.value.count == 1 { // 여기선 삭제되기 전의 값이라서 1개일 때가 다 지워진 것
                goToFillBox()
            } else { // 하위 목표가 다 지워진 게 아닌 경우에는 pop 안 함
                self.dismiss(animated: true) {
                    self.delegate?.updateDetailGoalList()
                }
            }
        }
    }
}
