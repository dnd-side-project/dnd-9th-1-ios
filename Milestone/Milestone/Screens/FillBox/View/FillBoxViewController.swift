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
    
    let ongoingGoalView = GoalStatusView()
    let completedGoalView = GoalStatusView()
        .then {
            $0.titleLabel.text = "완료한 목표"
            $0.goalNumberLabel.text = "12"
        }
    lazy var goalStatusStackView = UIStackView(arrangedSubviews: [ongoingGoalView, completedGoalView])
        .then {
            $0.axis = .horizontal
            $0.spacing = 14
            $0.distribution = .fillEqually
        }
    
    lazy var parentGoalTableView = UITableView(frame: CGRect(), style: .grouped)
        .then {
            $0.backgroundColor = .gray01
            $0.rowHeight = 96
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.register(cell: ParentGoalTableViewCell.self, forCellReuseIdentifier: ParentGoalTableViewCell.identifier)
            $0.dataSource = self
            $0.delegate = self
        }
    
    lazy var addGoalButton = UIButton()
        .then {
            $0.backgroundColor = .gray05
            $0.layer.cornerRadius = 64 / 2
            $0.setImage(ImageLiteral.imgPlus, for: .normal)
            $0.addTarget(self, action: #selector(addNewParentGoal), for: .touchUpInside)
            // 그림자 생성
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.4
            $0.layer.shadowOffset = CGSize(width: 0, height: 4)
            $0.layer.shadowRadius = 5
        }
    
    // MARK: - Properties
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([parentGoalTableView, addGoalButton])
        
        parentGoalTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(16)
        }
        addGoalButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.right.equalToSuperview().inset(24)
            make.width.height.equalTo(64)
        }
    }
    
    override func configUI() {
        view.backgroundColor = .gray01
        
        if #available(iOS 15, *) {
            parentGoalTableView.sectionHeaderTopPadding = 16
        }
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func addNewParentGoal() {
        // TODO: - 새 상위 목표 추가
        Logger.debugDescription("CLICK")
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FillBoxViewController: UITableViewDataSource, UITableViewDelegate {
    // 헤더뷰로 설정해서 같이 스크롤 되게 함
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        goalStatusStackView
    }
    // 헤더뷰 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        80
    }
    // 셀(상위 목표) 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    // 셀 내용 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ParentGoalTableViewCell.identifier, for: indexPath) as? ParentGoalTableViewCell else { return UITableViewCell() }
        return cell
    }
}
