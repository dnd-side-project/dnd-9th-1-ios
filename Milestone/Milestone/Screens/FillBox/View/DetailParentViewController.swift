//
//  DetailParentViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/11.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

// MARK: - UserDefaults에 사용되는 key 값 모음

enum UserDefaultsKey: String {
    case couchMark = "showCouchMark"
}

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
            $0.action = #selector(showMore)
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
    
    private var goalData: [DetailGoal] = [
//        DetailGoal(id: 0, isCompleted: true, title: "해커스 1000 LC 2 풀기"), DetailGoal(id: 1, isCompleted: true, title: "영단기 1000 RC 풀기"), DetailGoal(id: 2, isCompleted: true, title: "동사, 전치사 어휘 외우기"),
//        DetailGoal(id: 3, isCompleted: true, title: "오답 지문 해석하기"), DetailGoal(id: 4, title: "기출 문제 3회독 하기"), DetailGoal(id: 5, title: "단어 500개 외우기"),
//        DetailGoal(id: 6, title: "문법 문장 20개 외우기"), DetailGoal(id: 7, title: "모르는 단어 정리해두기")
    ]
    // goalData를 정렬한, 테이블뷰에 보여줄 데이터
    lazy var sortedGoalData: [DetailGoal] = {
        return sortGoalForCheckList(goalArray: goalData)
    }()
    // 세부 목표를 추가해주세요! 데이터
    private var emptyGoal: DetailGoal?
    private var couchMarkKey: String = UserDefaultsKey.couchMark.rawValue
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setEmptyGoalForCollectionView()
        checkFirstDetailView()
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
            make.height.equalTo(32)
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
    
    /// 여기 들어온 게 처음이 맞는지 확인 -> 맞으면 코치 마크 뷰 띄우기
    private func checkFirstDetailView() {
        if UserDefaults.standard.string(forKey: couchMarkKey) == nil {
            presentCouchMark()
        }
    }
    
    /// 코치 마크 뷰 띄우기
    private func presentCouchMark() {
        let couchMarkVC = CouchMarkViewController()
            .then {
                $0.modalPresentationStyle = .overFullScreen
                $0.modalTransitionStyle = .crossDissolve
            }
        present(couchMarkVC, animated: true)
        UserDefaults.standard.set("", forKey: couchMarkKey)
    }
    
    /// 체크리스트(TableView)를 위해 goalData를 정렬하는 함수
    /// 리스트는 id순(작성순)으로 정렬되어야 한다
    /// 또한 완료된 목표는 완료되지 않은 목표들보다 뒤에 위치해야 한다
    private func sortGoalForCheckList(goalArray: [DetailGoal]) -> [DetailGoal] {
        return goalArray.sorted {
            if $0.isCompleted == $1.isCompleted {
                return $0.id < $1.id
            } else {
                return !$0.isCompleted && $1.isCompleted
            }
        }
    }
    
    /// 파라미터로 받은 id가 배열에서 몇 번째 인덱스에 위치해 있는지 반환
    private func findIndex(id: Int, goalArray: [DetailGoal]) -> Int? {
        return goalArray.firstIndex { $0.id == id }
    }
    
    // MARK: - @objc Functions
    
    @objc
    func showMore() {
        let moreVC = MoreViewController()
        moreVC.modalPresentationStyle = .pageSheet
        
        guard let sheet = moreVC.sheetPresentationController else { return }
        let fraction = UISheetPresentationController.Detent.custom { _ in moreVC.viewHeight }
        sheet.detents = [fraction]
        present(moreVC, animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailInfo = DetailGoalInfoViewController()
        detailInfo.modalPresentationStyle = .overFullScreen
        detailInfo.modalTransitionStyle = .crossDissolve
        self.present(detailInfo, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension DetailParentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedGoalData.count
    }
                         
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailGoalTableViewCell.identifier, for: indexPath) as? DetailGoalTableViewCell else { return UITableViewCell() }
        cell.update(content: sortedGoalData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let selectedGoalId = sortedGoalData[row].id
        
        sortedGoalData[row].isCompleted.toggle() // 원본 배열의 isCompleted 값 변경
        sortedGoalData = sortGoalForCheckList(goalArray: sortedGoalData) // 원본 배열 재정렬
        
        let newIndex = findIndex(id: selectedGoalId, goalArray: sortedGoalData) // 재정렬된 배열과 비교하여 완료도가 업데이트된 목표가 들어가야할 인덱스를 찾는다
        let destIndexPath = IndexPath(row: newIndex ?? 0, section: 0) // 목적지 indexPath
        tableView.moveRow(at: indexPath, to: destIndexPath) // 해당 인덱스로 셀 이동
        
        guard let movedCell = tableView.cellForRow(at: destIndexPath) as? DetailGoalTableViewCell else { return } // 이동한 셀
        movedCell.update(content: sortedGoalData[newIndex ?? 0]) // 이동한 셀 UI 업데이트
        
        goalData[selectedGoalId].isCompleted.toggle() // 원본 배열의 isCompleted 값 변경
        self.detailGoalCollectionView.reloadData()
    }
}
