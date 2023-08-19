//
//  FillBoxViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/11.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

// MARK: - 채움함

class FillBoxViewController: BaseViewController {
    
    // MARK: - Subviews
    
    let parentGoalHeaderView = ParentGoalHeaderView()
    
    lazy var parentGoalTableView = UITableView(frame: CGRect(), style: .grouped)
        .then {
            $0.backgroundColor = .gray01
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.register(cell: ParentGoalTableViewCell.self, forCellReuseIdentifier: ParentGoalTableViewCell.identifier)
            $0.dataSource = self
            $0.delegate = self
        }
    
    lazy var addGoalButton = UIButton()
        .then {
            $0.backgroundColor = .primary
            $0.layer.cornerRadius = 64 / 2
            $0.setImage(ImageLiteral.imgPlus, for: .normal)
            $0.addTarget(self, action: #selector(presentAddParentGoal), for: .touchUpInside)
            $0.makeButtonShadow(color: .primary, alpha: 0.6, x: 0, y: 4, blur: 6, spread: 0)
        }
    
    private let bubbleView = BubbleView()
        .then {
            $0.guideLabel.text = "목표를 클릭하여 세부 목표를 설정해보세요!"
        }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parentGoalTableView.layoutIfNeeded()
        checkFirstFillBox()
        didScrollTableView()
    }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([parentGoalTableView, addGoalButton])
        
        parentGoalTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(20)
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
    
    /// 처음이 맞는지 확인 -> 맞으면 말풍선 뷰 띄우기
    private func checkFirstFillBox() {
        if UserDefaults.standard.string(forKey: "showBubble") == nil {
            addBubbleView()
        }
    }
    
    /// 말풍선 뷰 추가
    private func addBubbleView() {
        view.addSubview(bubbleView)
        bubbleView.snp.makeConstraints { make in
            Logger.debugDescription(parentGoalTableView.visibleCells)
            make.top.equalTo(parentGoalTableView.visibleCells[0].snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(268)
            make.height.equalTo(45)
        }
        UserDefaults.standard.set("", forKey: "showBubble")
    }
    
    private func didScrollTableView() {
        parentGoalTableView.rx.didScroll
            .subscribe { [weak self] _ in
                self?.removeBubbleView()
            }
            .disposed(by: disposeBag)
    }
    
    private func removeBubbleView() {
        bubbleView.removeFromSuperview()
    }
    
    // MARK: - @objc Functions
    
    @objc
    func presentAddParentGoal() {
        let addParentGoalVC = AddParentGoalViewController()
        addParentGoalVC.modalPresentationStyle = .pageSheet
        
        guard let sheet = addParentGoalVC.sheetPresentationController else { return }
        let fraction = UISheetPresentationController.Detent.custom { _ in addParentGoalVC.viewHeight }
        sheet.detents = [fraction]
        present(addParentGoalVC, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FillBoxViewController: UITableViewDataSource, UITableViewDelegate {
    
    // 헤더뷰로 설정해서 같이 스크롤 되게 함
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        parentGoalHeaderView
    }
    // 헤더뷰 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        80 + 8
    }
    // 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96 + 16
    }
    // 셀(상위 목표) 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    // 셀 내용 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ParentGoalTableViewCell.identifier, for: indexPath) as? ParentGoalTableViewCell else { return UITableViewCell() }
        return cell
    }
    // 셀 클릭 시 실행
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        push(viewController: DetailParentViewController())
    }
}
