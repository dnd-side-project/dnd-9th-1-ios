//
//  DetailUpperViewController.swift
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

class DetailUpperViewController: BaseViewController, ViewModelBindableType {
    
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
    lazy var lowerGoalCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flowLayout)
        .then {
            $0.backgroundColor = .gray01
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.register(cell: LowerGoalCollectionViewCell.self, forCellWithReuseIdentifier: LowerGoalCollectionViewCell.identifier)
            $0.delegate = self
        }
    lazy var lowerGoalTableView = UITableView()
        .then {
            $0.backgroundColor = .gray01
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.register(cell: LowerGoalTableViewCell.self, forCellReuseIdentifier: LowerGoalTableViewCell.identifier)
            $0.delegate = self
        }
    
    // MARK: - Properties
    
    var isFromStorage = false
    var viewModel: DetailUpperViewModel!
    var isUpperCompleted: Bool!
    
    // 하위 목표를 추가해주세요! 데이터
    private var emptyGoal: LowerGoal?
    private var couchMarkKey: String = UserDefaultsKeyStyle.couchMark.rawValue
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        updateLowerGoalList()
        checkFirstDetailView()
        updateDetailUpperView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateTableViewHeightForFit()
    }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubView(scrollView)
        scrollView.addSubView(contentView)
        contentView.addSubViews([goalTitleLabel, dDayLabel, termLabel, lowerGoalCollectionView, lowerGoalTableView, networkErrorToastView])
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.bottom.equalTo(lowerGoalTableView).offset(16)
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
        lowerGoalCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dDayLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(444 + 16)
        }
        lowerGoalTableView.snp.makeConstraints { make in
            make.top.equalTo(lowerGoalCollectionView.snp.bottom).offset(36)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(9 * (56 + 8)) // 최대 높이
        }
        networkErrorToastView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-50)
            make.height.equalTo(52)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
        }
    }
    
    override func configUI() {
        view.backgroundColor = .gray01
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func bindUI() {
        viewModel.popDetailUpperVC
            .subscribe { [self] popDetailUpperVC in
                if popDetailUpperVC {
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
        lowerGoalTableView.snp.updateConstraints { make in
            make.top.equalTo(lowerGoalCollectionView.snp.bottom).offset(36)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(viewModel.test.value.count * (56 + 8)) // 상세 목표 개수에 맞게 높이를 업데이트
        }
    }
    
    func bindViewModel() {
        if viewModel.isFull {
            viewModel.lowerGoalList
                .bind(to: lowerGoalCollectionView.rx.items(cellIdentifier: LowerGoalCollectionViewCell.identifier, cellType: LowerGoalCollectionViewCell.self)) { [unowned self] row, goal, cell in
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
                .bind(to: lowerGoalCollectionView.rx.items(cellIdentifier: LowerGoalCollectionViewCell.identifier, cellType: LowerGoalCollectionViewCell.self)) { [unowned self] row, goal, cell in
                    // 보관함일 때
                    if self.isFromStorage {
                        cell.isUserInteractionEnabled = false
                        cell.makeCellBlurry()
                    }
                    
                    Logger.debugDescription(viewModel.lowerGoalList.value.count)
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
            .bind(to: lowerGoalTableView.rx.items(cellIdentifier: LowerGoalTableViewCell.identifier, cellType: LowerGoalTableViewCell.self)) { _, goal, cell in
                if self.isFromStorage {
                    cell.isUserInteractionEnabled = false
                    cell.makeCellBlurry()
                }
                cell.update(content: goal)
            }
            .disposed(by: disposeBag)
        
        // 현재 상위 목표의 정보를 업데이트
        viewModel.thisUpperGoal
            .subscribe(onNext: { [unowned self] goal in
                goalTitleLabel.text = goal.title
                dDayLabel.text = isFromStorage ? "D + \(goal.dDay * -1)" : "D - \(goal.dDay)"
                termLabel.text = "\(goal.startDate) - \(goal.endDate)"
            })
            .disposed(by: disposeBag)
        
        viewModel.completedGoalResult
            .subscribe(onNext: { [unowned self] res in
                self.isUpperCompleted = res.isGoalCompleted
                if isUpperCompleted {
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
    private func updateDetailUpperView() {
        guard let selectedGoalData = viewModel.selectedUpperGoal else { return }
        viewModel.thisUpperGoal.accept(UpperGoalInfo(goalId: selectedGoalData.goalId, title: selectedGoalData.title, startDate: selectedGoalData.startDate, endDate: selectedGoalData.endDate, dDay: selectedGoalData.dDay))
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

extension DetailUpperViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 하위 목표 셀 클릭 시
        if viewModel.lowerGoalList.value.count > indexPath.row {
            var lowerInfoVC = LowerGoalInfoViewController()
            viewModel.lowerGoalId = viewModel.lowerGoalList.value[indexPath.row].detailGoalId
            lowerInfoVC.delegate = self
            lowerInfoVC.bind(viewModel: viewModel)
            lowerInfoVC.modalPresentationStyle = .overFullScreen
            lowerInfoVC.modalTransitionStyle = .crossDissolve
            self.present(lowerInfoVC, animated: true)
        } else { // 하위 목표를 추가해주세요! 셀 클릭 시
            let addLowerGoalVC = AddLowerGoalViewController()
            addLowerGoalVC.viewModel = viewModel
            addLowerGoalVC.delegate = self
            addLowerGoalVC.modalPresentationStyle = .pageSheet
            
            guard let sheet = addLowerGoalVC.sheetPresentationController else { return }
            let fraction = UISheetPresentationController.Detent.custom { _ in 500.0 }
            sheet.detents = [fraction]
            present(addLowerGoalVC, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension DetailUpperViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        9
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? LowerGoalTableViewCell else { return }
        let sortedGoalData = viewModel.sortedGoalData.value
        let row = indexPath.row
        let selectedGoal = sortedGoalData[row]
        
        viewModel.lowerGoalId = selectedGoal.detailGoalId
        
        // 버튼 클릭 시 연결 끊겼으면 토스트 애니메이션
        if !networkMonitor.isConnected.value {
            animateToastView(toastView: self.networkErrorToastView, yValue: 0)
        } else {
            if cell.containerView.backgroundColor == .white {
                // 하위 목표 달성
                viewModel.completeLowerGoal()
            } else {
                // 하위 목표 달성 취소
                viewModel.incompleteLowerGoal()
            }
        }
    }
}

// MARK: - UpdateLowerGoalListDelegate

extension DetailUpperViewController: UpdateLowerGoalListDelegate {
    /// 하위 목표 리스트 업데이트
    func updateLowerGoalList() {
        viewModel.retrieveLowerGoalList()
        updateTableViewHeightForFit()
    }
}
