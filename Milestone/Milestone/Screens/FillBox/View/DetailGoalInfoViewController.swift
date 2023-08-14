//
//  DetailGoalInfoViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/15.
//

import UIKit

import Then

// MARK: - 세부 목표 정보 팝업뷰

class DetailGoalInfoViewController: BaseViewController {
    
    // MARK: - SubViews
    
    let infoView = DetailGoalInfoView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGoalInfo()
    }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubView(infoView)
        
        infoView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    override func configUI() {
        view.backgroundColor = .black.withAlphaComponent(0.3) // dimmed view
    }
    
    /// TEMP
    private func setGoalInfo() {
        infoView.stoneImageView.image = ImageLiteral.imgDetailStoneVer1
        infoView.titleLabel.text = "테스트~"
        infoView.startDateLabel.text = "2033.02.02 시작"
    }
}
