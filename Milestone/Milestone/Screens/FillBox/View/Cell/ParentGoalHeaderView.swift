//
//  UpperGoalHeaderView.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/11.
//

import UIKit

import SnapKit
import Then

// MARK: - 상위 목표 테이블뷰의 헤더뷰

class UpperGoalHeaderView: UITableViewHeaderFooterView {
    
    let ongoingGoalView = GoalStatusView()
        .then {
            $0.titleLabel.text = "진행 중 목표"
            $0.goalNumberLabel.text = "4"
            $0.stoneImageView.image = ImageLiteral.imgOngoingGoal
        }
    let completedGoalView = GoalStatusView()
        .then {
            $0.stoneImageView.image = ImageLiteral.imgCompletedGoal
            $0.titleLabel.text = "완료한 목표"
            $0.goalNumberLabel.text = "12"
        }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        render()
    }
    
    private func render() {
        addSubViews([ongoingGoalView, completedGoalView])
        
        ongoingGoalView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        completedGoalView.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
        }
    }
}
