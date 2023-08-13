//
//  DetailParentViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/11.
//

import UIKit

import SnapKit
import Then

// MARK: - 상위 목표 상세 보기 화면

class DetailParentViewController: BaseViewController {
    
    // MARK: - Subviews
    
    lazy var leftBarButton = UIBarButtonItem()
        .then {
            $0.image = UIImage(systemName: "chevron.left")
            $0.style = .plain
            $0.tintColor = .gray05
            $0.target = self
            $0.action = #selector(pop)
        }
    lazy var rightBarButton = UIBarButtonItem()
        .then {
            $0.image = UIImage(systemName: "ellipsis")
            $0.style = .plain
            $0.tintColor = .gray05
            $0.target = self
            $0.action = #selector(pop) // TODO: - 나중에 바꿔야 함
        }
    
    private let scrollView = UIScrollView()
        .then {
            $0.backgroundColor = .gray01
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
    
    private let contentView = UIView()
        .then {
            $0.isUserInteractionEnabled = true
        }
    let goalTitleLabel = UILabel()
        .then {
            $0.text = "토익 900점 넘기기"
            $0.textColor = .black
            $0.font = .pretendard(.semibold, ofSize: 24)
        }
    let dDayLabel = UILabel()
        .then {
            $0.text = "D - 183"
            $0.textColor = .gray01
            $0.font = .pretendard(.semibold, ofSize: 12)
            $0.backgroundColor = .pointPurple
            $0.textAlignment = .center
            $0.layer.cornerRadius = 24 / 2
            $0.clipsToBounds = true
        }
    let termLabel = UILabel()
        .then {
            $0.text = "2023.09.08 - 2023.12.02"
            $0.font = .pretendard(.regular, ofSize: 12)
            $0.textColor = .gray03
        }
    
    let flowLayout = UICollectionViewFlowLayout()
        .then {
            $0.itemSize = CGSize(
                width: (UIScreen.main.bounds.width - 48 - 16) / 3,
                height: 148)
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 8
            $0.minimumInteritemSpacing = 0
        }
    lazy var detailGoalCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flowLayout)
        .then {
            $0.backgroundColor = .gray01
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.register(cell: DetailGoalCollectionViewCell.self, forCellWithReuseIdentifier: DetailGoalCollectionViewCell.identifier)
            $0.dataSource = self
            $0.delegate = self
        }
    lazy var detailGoalTableView = UITableView()
        .then {
            $0.backgroundColor = .gray01
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.register(cell: DetailGoalTableViewCell.self, forCellReuseIdentifier: DetailGoalTableViewCell.identifier)
            $0.dataSource = self
            $0.delegate = self
        }
    
    // MARK: - Properties
    
    private let goalData = [
        DetailGoal(isCompleted: true, title: "해커스 1000 LC 2 풀기"), DetailGoal(isCompleted: true, title: "영단기 1000 RC 풀기"), DetailGoal(isCompleted: true, title: "동사,전치사 어휘 외우기"),
        DetailGoal(isCompleted: true, title: "오답 지문 해석하기"), DetailGoal(title: "기출 문제 3회독 하기"), DetailGoal(title: "단어 500개 외우기"),
        DetailGoal(title: "문법 문장 20개 외우기"), DetailGoal(title: "모르는 단어 정리해두기")
    ]
    private var emptyGoal: DetailGoal? // 세부 목표를 추가해주세요! 데이터
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setEmptyGoalForCollectionView()
    }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubView(scrollView)
        scrollView.addSubView(contentView)
        contentView.addSubViews([goalTitleLabel, dDayLabel, termLabel, detailGoalCollectionView, detailGoalTableView])
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.bottom.equalTo(detailGoalTableView).offset(16)
        }
        goalTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(15)
        }
        dDayLabel.snp.makeConstraints { make in
            make.top.equalTo(goalTitleLabel.snp.bottom).offset(12)
            make.left.equalTo(goalTitleLabel)
            make.width.equalTo(58)
            make.height.equalTo(24)
        }
        termLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dDayLabel)
            make.left.equalTo(dDayLabel.snp.right).offset(8)
        }
        detailGoalCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dDayLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(444 + 16)
        }
        detailGoalTableView.snp.makeConstraints { make in
            make.top.equalTo(detailGoalCollectionView.snp.bottom).offset(36)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(goalData.count * (56 + 8))
        }
    }
    
    override func configUI() {
        view.backgroundColor = .gray01
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    /// 세부 목표를 추가해주세요! 뷰가 필요한 경우를 위해 설정하는 코드
    private func setEmptyGoalForCollectionView() {
        if goalData.count < 9 {
            self.emptyGoal = DetailGoal(isSet: false)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension DetailParentViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (goalData.count < 9) ? goalData.count + 1 : goalData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailGoalCollectionViewCell.identifier, for: indexPath) as? DetailGoalCollectionViewCell else { return UICollectionViewCell() }
        if let goal = indexPath.row < goalData.count ? goalData[indexPath.row] : emptyGoal {
            cell.update(content: goal, index: indexPath.row)
        }
        return cell
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension DetailParentViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filteredGoal = goalData.filter { section == 0 ? !($0.isCompleted) : $0.isCompleted }
        return filteredGoal.count
    }
                         
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailGoalTableViewCell.identifier, for: indexPath) as? DetailGoalTableViewCell else { return UITableViewCell() }
        let filteredGoal = goalData.filter { indexPath.section == 0 ? !($0.isCompleted) : ($0.isCompleted) }
        cell.update(content: filteredGoal[indexPath.row])
        return cell
    }
}
