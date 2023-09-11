//
//  LogoutViewController.swift
//  Milestone
//
//  Created by 박경준 on 2023/09/05.
//

import UIKit

import SnapKit
import Then

class ModalViewController: BaseViewController, ViewModelBindableType {
    
    // MARK: - Subviews
    
    lazy var askPopUpView = AskOneOfTwoView()
        .then {
            $0.noButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        }
    
    // MARK: - Properties
    
    var selectedRow = 0 {
        didSet {
            askPopUpView.yesButton.removeTarget(nil, action: nil, for: .allEvents)
            
            if selectedRow == 1 {
                askPopUpView.yesButton.addTarget(self, action: #selector(handleTapLogout), for: .touchUpInside)
            } else {
                askPopUpView.yesButton.addTarget(self, action: #selector(handleTapWithdraw), for: .touchUpInside)
            }
        }
    }
    
    var viewModel: SettingViewModel!
    
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
    
    // MARK: - @objc Functions
    
    @objc
    private func dismissViewController() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func handleTapLogout() {
        viewModel.handleLogout()
        dismissViewController()
    }
    
    @objc
    private func handleTapWithdraw() {
        viewModel.handleWithdraw()
        dismissViewController()
    }
}
