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

class FillBoxViewController: BaseViewController, ViewModelBindableType {
    
    // MARK: - Subviews
    
    let upperGoalHeaderView = UpperGoalHeaderView()
    
    lazy var upperGoalTableView = UITableView(frame: CGRect(), style: .grouped)
        .then {
            $0.backgroundColor = .gray01
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.register(cell: UpperGoalTableViewCell.self, forCellReuseIdentifier: UpperGoalTableViewCell.identifier)
            $0.delegate = self
        }
    
    lazy var addGoalButton = UIButton()
        .then {
            $0.backgroundColor = .primary
            $0.configuration = .plain()
            $0.layer.cornerRadius = 64 / 2
            $0.setImage(ImageLiteral.imgPlus, for: .normal)
            $0.addTarget(self, action: #selector(tapAddUpperGoalButton), for: .touchUpInside)
            $0.makeButtonShadow(color: .primary, alpha: 0.6, x: 0, y: 4, blur: 6, spread: 0)
        }
    
    private let bubbleView = BubbleView()
        .then {
            $0.guideLabel.text = "목표를 클릭하여 하위 목표를 설정해보세요!"
        }
    
    private var emptyFillBoxImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgEmptyFillBox
        }
    
    lazy var emptyGuideLabel = UILabel()
        .then {
            $0.text = " 앗! 설정한 목표가 없으시네요!"
            $0.textColor = .gray02
            $0.font = .pretendard(.semibold, ofSize: 18)
            $0.textAlignment = .center
        }
    
    private let addNewGoalBubbleView = BubbleTailDownView()
        .then {
            $0.guideLabel.text = "이루고 싶은 목표를 설정해주세요!"
        }
    
    // MARK: - Properties
    
    var viewModel: FillBoxViewModel! = FillBoxViewModel()
    var bubbleKey = UserDefaultsKeyStyle.bubbleInFillBox.rawValue
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        upperGoalTableView.layoutIfNeeded()
        checkFirstFillBox()
        didScrollTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUpperGoalList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.checkRecommendViewPresentCondition()
        }
    }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([upperGoalTableView, addGoalButton, emptyFillBoxImageView, emptyGuideLabel, addNewGoalBubbleView])
        upperGoalTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(16)
        }
        addGoalButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.right.equalToSuperview().inset(24)
            make.width.height.equalTo(64)
        }
        emptyFillBoxImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(144)
            make.centerX.equalToSuperview()
        }
        emptyGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyFillBoxImageView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        addNewGoalBubbleView.snp.makeConstraints { make in
            make.bottom.equalTo(addGoalButton.snp.top).offset(-25)
            make.right.equalTo(addGoalButton.snp.right)
            make.width.equalTo(216)
            make.height.equalTo(45)
        }
    }
    
    override func configUI() {
        view.backgroundColor = .gray01
        
        if #available(iOS 15, *) {
            upperGoalTableView.sectionHeaderTopPadding = 16
        }
    }
    
    func bindViewModel() {
        viewModel.progressGoals
            .bind(to: upperGoalTableView.rx.items(cellIdentifier: UpperGoalTableViewCell.identifier, cellType: UpperGoalTableViewCell.self)) { _, goal, cell in
                cell.goalAchievementRateView.completedCount = CGFloat(goal.completedDetailGoalCnt)
                cell.goalAchievementRateView.totalCount = CGFloat(goal.entireDetailGoalCnt)
                cell.titleLabel.text = goal.title
                cell.termLabel.text = "\(goal.startDate) - \(goal.endDate)"
            }
            .disposed(by: disposeBag)
        
        // viewModel.progressGoals 데이터가 세팅이 되었을 때 실행됨
        viewModel.isSet
            .subscribe { isSet in
                if isSet {
                    self.updateFillBoxVisibility()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.progressGoalCount
            .bind(to: upperGoalHeaderView.ongoingGoalView.goalNumberLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.completedGoalCount
            .bind(to: upperGoalHeaderView.completedGoalView.goalNumberLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    /// 처음이 맞는지 확인 -> 맞으면 말풍선 뷰 띄우기
    private func checkFirstFillBox() {
        if !UserDefaults.standard.bool(forKey: bubbleKey) { // 처음이면 무조건 false 반환함
            UserDefaults.standard.set(true, forKey: bubbleKey)
            addBubbleView()
        }
    }
    
    /// 목표의 개수에 따라 채움함의 뷰의 isHidden 상태를 업데이트
    /// 개수가 0개이면 채움함이 빈 화면이라는 것을 알려주는 이미지가 뜨고
    /// 아니면 상위 목표 목록이 뜬다
    private func updateFillBoxVisibility() {
        let isEmpty = viewModel.progressGoals.value.isEmpty
        [emptyFillBoxImageView, emptyGuideLabel, addNewGoalBubbleView]
            .forEach { $0.isHidden = !isEmpty }
        upperGoalTableView.visibleCells
            .forEach { $0.isHidden = isEmpty }
        upperGoalTableView.reloadData()
    }
    
    /// 말풍선 뷰 추가
    private func addBubbleView() {
        view.addSubview(bubbleView)
        bubbleView.snp.makeConstraints { make in
            make.top.equalTo(upperGoalTableView).offset(16 + 88 + 96 + 16)
            make.centerX.equalToSuperview()
            make.width.equalTo(268)
            make.height.equalTo(45)
        }
    }
    
    private func didScrollTableView() {
        upperGoalTableView.rx.didScroll
            .subscribe { [weak self] _ in
                self?.removeBubbleView()
            }
            .disposed(by: disposeBag)
    }
    
    private func removeBubbleView() {
        bubbleView.removeFromSuperview()
    }
    
    private func presentAddUpperGoal() {
        var addUpperGoalVC = AddUpperGoalViewController()
            .then {
                $0.enterGoalDateView.startDate = Date()
                let sevenDaysInterval: TimeInterval = 7 * 24 * 60 * 60
                let endDate = Date().addingTimeInterval(sevenDaysInterval)
                $0.enterGoalDateView.endDate = endDate
                $0.enterGoalDateView.setDatePicker()
                $0.delegate = self
            }
        addUpperGoalVC.bind(viewModel: DetailUpperViewModel())
        presentCustomModal(addUpperGoalVC, height: addUpperGoalVC.viewHeight)
    }
    
    /// 목표를 완료한 후인지 + 보관함에 목표가 1개 이상 있는지 확인
    /// 조건을 만족한다면 목표 권유(추천) 팝업 뷰를 띄운다
    private func checkRecommendViewPresentCondition() {
        let storedGoalCount = Int(viewModel.storedGoalCount.value) ?? 3 // 보관함에 있는 목표 개수
        if UserDefaults.standard.bool(forKey: UserDefaultsKeyStyle.recommendGoalView.rawValue) && storedGoalCount > 0 {
            let recommendGoalVC = RecommendGoalViewController()
                .then {
                    $0.modalTransitionStyle = .crossDissolve
                    $0.modalPresentationStyle = .overFullScreen
                    $0.cellNum = (storedGoalCount > 3) ? 3 : storedGoalCount // 최대가 3개 크기
                }
            self.present(recommendGoalVC, animated: true)
            
            // 저장된 값을 false로 원상 복구
            UserDefaults.standard.set(false, forKey: UserDefaultsKeyStyle.recommendGoalView.rawValue)
        }
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func tapAddUpperGoalButton() {
        // 클릭 스타일로 배경색 변경
        addGoalButton.backgroundColor = .init(hex: "#2B75D4")
        
        // 바뀐 배경색이 보일 수 있게 0.01초만 딜레이
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
            addGoalButton.backgroundColor = .primary // 다시 색깔 복구
            presentAddUpperGoal() // 모달 뷰 띄우기
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FillBoxViewController: UITableViewDelegate {
    // 헤더뷰로 설정해서 같이 스크롤 되게 함
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        upperGoalHeaderView
    }
    // 헤더뷰 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        80 + 8
    }
    // 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96 + 16
    }
    // 셀 클릭 시 실행
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGoalData = self.viewModel.progressGoals.value[indexPath.row]
        let nextVC = DetailUpperViewController()
        let viewModel = DetailUpperViewModel()
        viewModel.selectedUpperGoal = selectedGoalData
        nextVC.viewModel = viewModel
        push(viewController: nextVC)
    }
}

extension FillBoxViewController: UpdateUpperGoalListDelegate {
    func updateUpperGoalList() {
        viewModel.clearList()
        // 상위 목표 상태별 개수 조회 API 호출
        viewModel.retrieveGoalCountByStatus()
    }
}

extension FillBoxViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !viewModel.progressGoals.value.isEmpty {
            if self.upperGoalTableView.contentOffset.y > self.upperGoalTableView.contentSize.height - self.upperGoalTableView.frame.size.height - 100 {
                if (!viewModel.isLoading) && (!viewModel.isLastPage) {
                    viewModel.retrieveUpperGoalList()
                }
            }
        }
    }
}
