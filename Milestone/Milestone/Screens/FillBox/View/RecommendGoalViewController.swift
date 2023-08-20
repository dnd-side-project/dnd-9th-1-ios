//
//  RecommendGoalViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/20.
//

import UIKit

import SnapKit
import Then

class RecommendGoalViewController: BaseViewController {
    
    // MARK: - Subviews
    
    lazy var containerView = UIView()
        .then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
            $0.makeShadow(color: .init(hex: "#464646", alpha: 0.4), alpha: 1, x: 0, y: 8, blur: 10, spread: 0)
        }
    let xButton = UIButton(type: .custom)
        .then {
            $0.setImage(ImageLiteral.imgX, for: .normal)
        }
    lazy var guideLabel = UILabel()
        .then {
            let contentString = "잠깐만요!\n목표를 이룬 당신에게 추천해요\n이 목표들을 다시 해보는건 어때요?"
            $0.text = contentString
            $0.textColor = .black
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: contentString)
            attributedString.setColorForText(textForAttribute: "이 목표", withColor: .pointPurple)
            $0.attributedText = attributedString
            $0.setLineSpacing(lineHeightMultiple: 1.2)
            $0.numberOfLines = 3
            $0.font = .pretendard(.semibold, ofSize: 18)
            $0.textAlignment = .left
        }
    lazy var recommendGoalTableView = UITableView()
        .then {
            $0.backgroundColor = .white
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.register(cell: ParentGoalTableViewCell.self, forCellReuseIdentifier: ParentGoalTableViewCell.identifier)
            $0.dataSource = self
            $0.delegate = self
        }
    lazy var goToStorageButton = UIButton()
        .then {
            $0.titleLabel?.font = .pretendard(.semibold, ofSize: 16)
            $0.layer.cornerRadius = 20
            $0.setTitle("보관함 가기", for: .normal)
            $0.setTitleColor(.primary, for: .normal)
            $0.backgroundColor = .secondary03
        }
    
    // MARK: - Properties
    // MARK: - Life Cycle
    
    // MARK: - Functions
    
    override func render() {
        view.addSubView(containerView)
        containerView.addSubViews([xButton, guideLabel, recommendGoalTableView, goToStorageButton])
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(550)
            make.width.equalTo(342)
        }
        xButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(24)
            make.width.height.equalTo(24)
        }
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(xButton.snp.bottom)
            make.left.equalToSuperview().inset(24)
            make.right.equalTo(xButton)
        }
        recommendGoalTableView.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo((96 + 16) * 3)
        }
        goToStorageButton.snp.makeConstraints { make in
            make.top.equalTo(recommendGoalTableView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
    }
    override func configUI() {
        view.backgroundColor = .init(hex: "#000000", alpha: 0.3)
    }
    
    // MARK: - @objc Functions
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension RecommendGoalViewController: UITableViewDelegate, UITableViewDataSource {
    // 셀(상위 목표) 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    // 셀 내용 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ParentGoalTableViewCell.identifier, for: indexPath) as? ParentGoalTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .white
        cell.containerView.layer.shadowColor = UIColor.clear.cgColor
        cell.containerView.layer.borderWidth = 1
        cell.containerView.layer.borderColor = UIColor.secondary01.cgColor
        return cell
    }
    // 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96 + 16
    }
    // 셀 클릭 시 실행
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        push(viewController: DetailParentViewController())
//    }
}
