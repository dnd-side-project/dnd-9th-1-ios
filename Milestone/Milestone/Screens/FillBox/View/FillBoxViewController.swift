//
//  FillBoxViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/11.
//

import UIKit

import SnapKit
import Then

// MARK: - 채움함

class FillBoxViewController: BaseViewController {
    
    // MARK: - Subviews
    
    let goal1 = GoalStatusView()
    let goal2 = GoalStatusView()
        .then {
            $0.titleLabel.text = "완료한 목표"
            $0.goalNumberLabel.text = "12"
        }
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray01
    }
    
    // MARK: - Functions
    
    override func configUI() {
        view.addSubViews([goal1, goal2])
    }
    
    override func render() {
        goal1.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(24)
        }
        goal2.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(24)
        }
    }
    
    // MARK: - @objc Functions
    
}
