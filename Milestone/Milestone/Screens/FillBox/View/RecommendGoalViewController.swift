//
//  RecommendGoalViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/20.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

// MARK: - 목표 권유 팝업 뷰

class RecommendGoalViewController: BaseViewController, ViewModelBindableType {
    
    // MARK: - Subviews
    
    lazy var containerView = UIView()
        .then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
            $0.makeShadow(color: .init(hex: "#464646", alpha: 0.4), alpha: 1, x: 0, y: 8, blur: 10, spread: 0)
        }
    let xButton = UIButton()
        .then {
            $0.configuration = .plain()
            $0.setImage(ImageLiteral.imgX, for: .normal)
        }
    lazy var guideLabel = UILabel()
        .then {
            let contentString = "잠깐만요!\n목표를 이룬 당신에게 추천해요\n이 목표들을 다시 해보는 건 어때요?"
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
    lazy var recommendGoalTableView = ContentSizedTableView()
        .then {
            $0.backgroundColor = .white
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.register(cell: ParentGoalTableViewCell.self, forCellReuseIdentifier: ParentGoalTableViewCell.identifier)
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
    
    var viewModel: FillBoxViewModel! = FillBoxViewModel()
    var cellNum = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.retrieveRecommendGoal()
    }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubView(containerView)
        containerView.addSubViews([xButton, guideLabel, recommendGoalTableView, goToStorageButton])
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(128 + ((8 + 96 + 8) * cellNum) + 8 + 54 + 24)
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
    
    override func bindUI() {
        xButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first, touch.view == view {
            dismiss(animated: true) // 배경 클릭 시 dismiss
        }
    }
    
    func bindViewModel() {
        viewModel.recommendedGoals
            .bind(to: recommendGoalTableView.rx.items(cellIdentifier: ParentGoalTableViewCell.identifier, cellType: ParentGoalTableViewCell.self)) { _, goal, cell in
                cell.backgroundColor = .white
                cell.containerView.layer.shadowColor = UIColor.clear.cgColor
                cell.containerView.layer.borderWidth = 1
                cell.containerView.layer.borderColor = UIColor.secondary01.cgColor
                cell.goalAchievementRateView.completedCount = CGFloat(goal.completedDetailGoalCnt)
                cell.goalAchievementRateView.totalCount = CGFloat(goal.entireDetailGoalCnt)
                cell.titleLabel.text = goal.title
                cell.termLabel.text = "\(goal.startDate) - \(goal.endDate)"
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - @objc Functions
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension RecommendGoalViewController: UITableViewDelegate {
    // 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96 + 16
    }
}
