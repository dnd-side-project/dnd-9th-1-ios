//
//  StorageBoxViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/11.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

// MARK: - 보관함 화면

class StorageBoxViewController: BaseViewController {
    
    // MARK: - Subviews
    
    let emptyStorageImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgEmptyStorage
        }
    lazy var firstEmptyGuideLabel = UILabel()
        .then {
            $0.text = "기간 내에 완료하지 못한\n목표들이 보관됩니다."
            $0.numberOfLines = 2
            $0.setLineSpacing(lineHeightMultiple: 1.2)
            $0.textColor = .gray02
            $0.font = .pretendard(.semibold, ofSize: 18)
            $0.textAlignment = .center
        }
    let secondEmptyGuideLabel = UILabel()
        .then {
            $0.text = "언제든지 다시 시작할 수 있어요!"
            $0.textColor = .gray02
            $0.font = .pretendard(.semibold, ofSize: 18)
            $0.textAlignment = .center
        }
    lazy var storageGoalTableView = UITableView(frame: CGRect(), style: .grouped)
        .then {
            $0.backgroundColor = .gray01
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.register(cell: ParentGoalTableViewCell.self, forCellReuseIdentifier: ParentGoalTableViewCell.identifier)
            $0.dataSource = self
            $0.delegate = self
        }
    let headerContainerView = UIView()
    lazy var alertView = CompletionAlertView()
        .then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
        }
    
    // MARK: - Properties
    
    var goals = BehaviorRelay<[ParentGoal]>(value: [ParentGoal()])
    lazy var goalsValue = goals.value
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 보관함의 빈 화면과 보관함 채워져있는 화면 간의 전환하는 테스트를 위해 화면 보일 때마다 계속 1개씩 추가해줌
        goalsValue.append(ParentGoal())
        updateStorageVisibility()
    }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([emptyStorageImageView, firstEmptyGuideLabel, secondEmptyGuideLabel, storageGoalTableView])
        emptyStorageImageView.snp.makeConstraints { make in
            make.width.height.equalTo(250)
            make.top.equalToSuperview().inset(127)
            make.centerX.equalToSuperview()
        }
        firstEmptyGuideLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyStorageImageView.snp.bottom).offset(24)
        }
        secondEmptyGuideLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(firstEmptyGuideLabel.snp.bottom).offset(14)
        }
        storageGoalTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configUI() {
        if #available(iOS 15, *) {
            storageGoalTableView.sectionHeaderTopPadding = 12
        }
    }
    
    override func bindUI() {
        goals
            .subscribe { [unowned self] _ in
                updateStorageVisibility()
            }
            .disposed(by: disposeBag)
    }
    
    /// goals의 개수에 따라 보관함의 뷰의 isHidden 상태와 label에 적히는 목표 개수를 업데이트 한다
    private func updateStorageVisibility() {
        [emptyStorageImageView, firstEmptyGuideLabel, secondEmptyGuideLabel]
            .forEach { $0.isHidden = !goalsValue.isEmpty }
        storageGoalTableView.isHidden = goalsValue.isEmpty
        storageGoalTableView.reloadData()
        updateStorageBoxTopLabel()
    }
    
    /// 보관함 맨 위 label에 들어가는 목표 개수 정보와 스타일을 업데이트 해줌
    private func updateStorageBoxTopLabel() {
        let stringValue = "총 \(goalsValue.count)개의 목표가 보관되어있어요!"
        alertView.label.text = stringValue
        alertView.label.textColor = .black
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColorForText(textForAttribute: "총 \(goalsValue.count)개의 목표", withColor: .pointPurple)
        alertView.label.attributedText = attributedString
    }
}

extension StorageBoxViewController: UITableViewDelegate, UITableViewDataSource {
    // alert 뷰를 헤더뷰로 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerContainerView.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(4)
            make.height.equalTo(60)
        } // 컨테이너 안에서 레이아웃 조정
        return headerContainerView
    }
    // 헤더뷰 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60 + 8
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        goalsValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ParentGoalTableViewCell.identifier, for: indexPath) as? ParentGoalTableViewCell else { return UITableViewCell() }
        let goal = goalsValue[indexPath.row]
        cell.titleLabel.text = goal.title
        cell.termLabel.text = "\(goal.startDate) - \(goal.endDate)"
        return cell
    }
    // 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96 + 16
    }
    // 보관함 빈 화면 잘 나오는지 테스트하기 위한 용도입니다!!!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goalsValue.remove(at: indexPath.row) // 삭제
        goals.accept(goalsValue) // 변경된 배열로 업데이트
        tableView.reloadData() // 테이블뷰 UI 업데이트
    }
}
