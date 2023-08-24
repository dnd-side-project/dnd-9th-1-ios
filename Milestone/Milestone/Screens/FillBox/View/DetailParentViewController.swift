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

// MARK: - 상위 목표 상세 보기 화면

class DetailParentViewController: BaseViewController, ViewModelBindableType {
    
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
    lazy var dDayLabel = UILabel()
        .then {
            $0.text = isFromStorage ? "D + 12" : "D - 183"
            $0.textColor = .gray01
            $0.font = .pretendard(.semibold, ofSize: 12)
            $0.backgroundColor = isFromStorage ? .gray04 : .pointPurple
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
            $0.delegate = self
        }
    lazy var detailGoalTableView = UITableView()
        .then {
            $0.backgroundColor = .gray01
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.register(cell: DetailGoalTableViewCell.self, forCellReuseIdentifier: DetailGoalTableViewCell.identifier)
            $0.delegate = self
        }
    
    // MARK: - Properties
    
    var isFromStorage = false
    var viewModel: DetailParentViewModel!
    
    // 세부 목표를 추가해주세요! 데이터
    private var emptyGoal: DetailGoal?
    private var couchMarkKey: String = UserDefaultsKeyStyle.couchMark.rawValue
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        updateDetailGoalList()
        checkFirstDetailView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateTableViewHeightForFit()
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
            make.height.equalTo(9 * (56 + 8)) // 최대 높이
        }
    }
    
    override func configUI() {
        view.backgroundColor = .gray01
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func updateTableViewHeightForFit() {
        detailGoalTableView.snp.updateConstraints { make in
            make.top.equalTo(detailGoalCollectionView.snp.bottom).offset(36)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(viewModel.test.value.count * (56 + 8)) // 상세 목표 개수에 맞게 높이를 업데이트
        }
    }
    
    func bindViewModel() {
        updateDetailGoalList()
        
        if viewModel.isFull {
            viewModel.detailGoalList
                .bind(to: detailGoalCollectionView.rx.items(cellIdentifier: DetailGoalCollectionViewCell.identifier, cellType: DetailGoalCollectionViewCell.self)) { [unowned self] row, goal, cell in
                    // 보관함일 때
                    if self.isFromStorage {
                        cell.isUserInteractionEnabled = false
                        cell.makeCellBlurry()
                    }
                    
                    cell.titleLabel.text = goal.title
                    cell.stoneImageView.image = goal.isCompleted ? self.viewModel.completedImageArray[row] : self.viewModel.stoneImageArray[row]
                }
                .disposed(by: disposeBag)
        } else {
            viewModel.test
                .bind(to: detailGoalCollectionView.rx.items(cellIdentifier: DetailGoalCollectionViewCell.identifier, cellType: DetailGoalCollectionViewCell.self)) { [unowned self] row, goal, cell in
                    // 보관함일 때
                    if self.isFromStorage {
                        cell.isUserInteractionEnabled = false
                        cell.makeCellBlurry()
                    }
                    
                    Logger.debugDescription(viewModel.detailGoalList.value.count)
                    if row < viewModel.test.value.count - 1 {
                        cell.titleLabel.text = goal.title
                        cell.stoneImageView.image = goal.isCompleted ? self.viewModel.completedImageArray[row] : self.viewModel.stoneImageArray[row]
                    } else {
                        cell.titleLabel.text = goal.title
                        cell.titleLabel.textColor = .gray02
                        cell.stoneImageView.image = ImageLiteral.imgAddStone
                    }
                }
                .disposed(by: disposeBag)
        }
        
        viewModel.detailGoalList
            .bind(to: detailGoalTableView.rx.items(cellIdentifier: DetailGoalTableViewCell.identifier, cellType: DetailGoalTableViewCell.self)) { _, goal, cell in
                Logger.debugDescription("여기 \(cell.titleLabel.text)")
                if self.isFromStorage {
                    cell.isUserInteractionEnabled = false
                    cell.makeCellBlurry()
                }
                cell.titleLabel.text = goal.title
                cell.containerView.backgroundColor = goal.isCompleted ? .secondary03 : .white
                cell.titleLabel.textColor = goal.isCompleted ? .primary : .black
                cell.checkImageView.image = goal.isCompleted ? ImageLiteral.imgBlueCheck : ImageLiteral.imgWhiteCheck
            }
            .disposed(by: disposeBag)
    }
    
    /// 여기 들어온 게 처음이 맞는지 확인 -> 맞으면 코치 마크 뷰 띄우기
    private func checkFirstDetailView() {
        if !UserDefaults.standard.bool(forKey: couchMarkKey) {
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
        UserDefaults.standard.set(true, forKey: couchMarkKey)
    }
    
//    /// 파라미터로 받은 id가 배열에서 몇 번째 인덱스에 위치해 있는지 반환
//    private func findIndex(id: Int, goalArray: [DetailGoalTemp]) -> Int? {
//        return goalArray.firstIndex { $0.id == id }
//    }
    
    // MARK: - @objc Functions
    
    @objc
    func showMore() {
        lazy var moreVC = MoreViewController()
            .then {
                $0.isFromStorage = isFromStorage
            }
        presentCustomModal(moreVC, height: moreVC.viewHeight)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension DetailParentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DetailGoalCollectionViewCell else { return }
        if cell.isSet.value {
            let detailInfo = DetailGoalInfoViewController()
            detailInfo.modalPresentationStyle = .overFullScreen
            detailInfo.modalTransitionStyle = .crossDissolve
            self.present(detailInfo, animated: true)
        } else {
            let addDetailGoalVC = AddDetailGoalViewController()
            addDetailGoalVC.viewModel = AddDetailGoalViewModel()
            addDetailGoalVC.delegate = self
            addDetailGoalVC.parentGoalId = self.viewModel.parentGoalId
            addDetailGoalVC.modalPresentationStyle = .pageSheet

            guard let sheet = addDetailGoalVC.sheetPresentationController else { return }
            let fraction = UISheetPresentationController.Detent.custom { _ in 500.0 }
            sheet.detents = [fraction]
            present(addDetailGoalVC, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension DetailParentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        9
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let row = indexPath.row
//        let selectedGoalId = sortedGoalData[row].id
//
//        sortedGoalData[row].isCompleted.toggle() // 원본 배열의 isCompleted 값 변경
//        sortedGoalData = sortGoalForCheckList(goalArray: sortedGoalData) // 원본 배열 재정렬
//
//        let newIndex = findIndex(id: selectedGoalId, goalArray: sortedGoalData) // 재정렬된 배열과 비교하여 완료도가 업데이트된 목표가 들어가야할 인덱스를 찾는다
//        let destIndexPath = IndexPath(row: newIndex ?? 0, section: 0) // 목적지 indexPath
//        tableView.moveRow(at: indexPath, to: destIndexPath) // 해당 인덱스로 셀 이동
//
//        guard let movedCell = tableView.cellForRow(at: destIndexPath) as? DetailGoalTableViewCell else { return } // 이동한 셀
//        movedCell.update(content: sortedGoalData[newIndex ?? 0]) // 이동한 셀 UI 업데이트
//
//        goalData[selectedGoalId].isCompleted.toggle() // 원본 배열의 isCompleted 값 변경
//        self.detailGoalCollectionView.reloadData()
//    }
}

// MARK: - UpdateDetailGoalListDelegate

extension DetailParentViewController: UpdateDetailGoalListDelegate {
    /// 세부 목표 리스트 업데이트
    func updateDetailGoalList() {
        viewModel.retrieveDetailGoalList()
        updateTableViewHeightForFit()
    }
}
