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
    
    lazy var leftBarButton = DefaultLeftBarButton()
        .then {
            $0.target = self
            $0.action = #selector(pop)
        }
    lazy var rightBarButton = UIBarButtonItem()
        .then {
            $0.image = UIImage(systemName: "ellipsis")
            $0.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10.0)
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
    var isParentCompleted: Bool!
    
    // 하위 목표를 추가해주세요! 데이터
    private var emptyGoal: DetailGoal?
    private var couchMarkKey: String = UserDefaultsKeyStyle.couchMark.rawValue
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        updateDetailGoalList()
        checkFirstDetailView()
        updateDetailParentView()
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
    
    override func bindUI() {
        viewModel.popDetailParentVC
            .subscribe { [self] popDetailParentVC in
                if popDetailParentVC {
                    pop()
                    // 현재 스택에 있는 뷰 컨트롤러들을 가져오고, 가장 상위의 뷰 컨트롤러를 제거
//                    if var viewControllers = navigationController?.viewControllers {
//                        navigationController?.change
//                        viewControllers.removeLast()
//                        let text = DetailParentViewController()
//                        text.viewModel = DetailParentViewModel()
//                        viewControllers.append(text)
//                        navigationController?.setViewControllers(viewControllers, animated: true)
                    }
                }
            .disposed(by: disposeBag)
    }
    
    private func updateTableViewHeightForFit() {
        detailGoalTableView.snp.updateConstraints { make in
            make.top.equalTo(detailGoalCollectionView.snp.bottom).offset(36)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(viewModel.test.value.count * (56 + 8)) // 상세 목표 개수에 맞게 높이를 업데이트
        }
    }
    
    func bindViewModel() {
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
        
        viewModel.sortedGoalData
            .bind(to: detailGoalTableView.rx.items(cellIdentifier: DetailGoalTableViewCell.identifier, cellType: DetailGoalTableViewCell.self)) { _, goal, cell in
                if self.isFromStorage {
                    cell.isUserInteractionEnabled = false
                    cell.makeCellBlurry()
                }
                cell.update(content: goal)
            }
            .disposed(by: disposeBag)
        
        // 현재 상위 목표의 정보를 업데이트
        viewModel.thisParentGoal
            .subscribe(onNext: { [unowned self] goal in
                goalTitleLabel.text = goal.title
                dDayLabel.text = isFromStorage ? "D + \(goal.dDay * -1)" : "D - \(goal.dDay)"
                termLabel.text = "\(goal.startDate) - \(goal.endDate)"
            })
            .disposed(by: disposeBag)
        
        viewModel.completedGoalResult
            .subscribe(onNext: { [unowned self] res in
                self.isParentCompleted = res.isGoalCompleted
                if isParentCompleted {
                    let vc = CompleteGoalViewController()
                        .then {
                            $0.viewModel = viewModel
                            $0.modalPresentationStyle = .overFullScreen
                            $0.modalTransitionStyle = .crossDissolve
                        }
                    self.present(vc, animated: true)
                }
            })
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
    
    /// 상위 목표 정보로 뷰 구성
    private func updateDetailParentView() {
        guard let selectedGoalData = viewModel.selectedParentGoal else { return }
        viewModel.thisParentGoal.accept(ParentGoalInfo(goalId: selectedGoalData.goalId,
                                                       title: selectedGoalData.title,
                                                       startDate: selectedGoalData.startDate,
                                                       endDate: selectedGoalData.endDate,
                                                       dDay: selectedGoalData.dDay))
    }
    
    // MARK: - @objc Functions
    
    @objc
    func showMore() {
        lazy var moreVC = MoreViewController()
            .then {
                $0.isFromStorage = isFromStorage
                $0.viewModel = viewModel
            }
        presentCustomModal(moreVC, height: moreVC.viewHeight)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension DetailParentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 하위 목표 셀 클릭 시
        if viewModel.detailGoalList.value.count > indexPath.row {
            var detailInfoVC = DetailGoalInfoViewController()
            viewModel.detailGoalId = viewModel.detailGoalList.value[indexPath.row].detailGoalId
            detailInfoVC.delegate = self
            detailInfoVC.bind(viewModel: viewModel)
            detailInfoVC.modalPresentationStyle = .overFullScreen
            detailInfoVC.modalTransitionStyle = .crossDissolve
            self.present(detailInfoVC, animated: true)
        } else { // 하위 목표를 추가해주세요! 셀 클릭 시
            let addDetailGoalVC = AddDetailGoalViewController()
            addDetailGoalVC.viewModel = viewModel
            addDetailGoalVC.delegate = self
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? DetailGoalTableViewCell else { return }
        let sortedGoalData = viewModel.sortedGoalData.value
        let row = indexPath.row
        let selectedGoal = sortedGoalData[row]
        
        viewModel.detailGoalId = selectedGoal.detailGoalId
        if cell.containerView.backgroundColor == .white {
            // 하위 목표 달성
            viewModel.completeDetailGoal()
        } else {
            // 하위 목표 달성 취소
            viewModel.incompleteDetailGoal()
        }
    }
}

// MARK: - UpdateDetailGoalListDelegate

extension DetailParentViewController: UpdateDetailGoalListDelegate {
    /// 하위 목표 리스트 업데이트
    func updateDetailGoalList() {
        viewModel.retrieveDetailGoalList()
        updateTableViewHeightForFit()
    }
}
