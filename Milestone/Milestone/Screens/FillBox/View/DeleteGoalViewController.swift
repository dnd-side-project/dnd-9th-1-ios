//
//  DeleteGoalViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/19.
//

import UIKit

import SnapKit
import Then

// MARK: - 목표 삭제 팝업 뷰 (상위, 세부 목표 동일하게 사용)

class DeleteGoalViewController: BaseViewController {
    
    // MARK: - Subviews
    
    // MARK: - Properties
    
    var fromParentGoal = true // 상위 목표 수정인지 세부 목표 수정인지
    
    // MARK: - Functions
    
    override func render() {
        
    }

    override func configUI() {
        view.backgroundColor = .init(hex: "#000000", alpha: 0.3)
    }
    
    // MARK: - @objc Functions
}
