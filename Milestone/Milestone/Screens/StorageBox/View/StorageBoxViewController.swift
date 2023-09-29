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

class StorageBoxViewController: BaseViewController, ViewModelBindableType {
    
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
            $0.register(cell: UpperGoalTableViewCell.self, forCellReuseIdentifier: UpperGoalTableViewCell.identifier)
            $0.delegate = self
        }
    let headerContainerView = UIView()
    lazy var alertView = CompletionAlertView()
        .then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
        }
    
    // MARK: - Properties
    
    var viewModel: StorageBoxViewModel! = StorageBoxViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.clearList()
        viewModel.retrieveStorageGoalList()
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
    
    func bindViewModel() {
        viewModel.storedGoals
            .bind(to: storageGoalTableView.rx.items(cellIdentifier: UpperGoalTableViewCell.identifier, cellType: UpperGoalTableViewCell.self)) { _, goal, cell in
                cell.titleLabel.text = goal.title
                cell.termLabel.text = "\(goal.startDate) - \(goal.endDate)"
                cell.goalAchievementRateView.completedCount = CGFloat(goal.completedDetailGoalCnt)
                cell.goalAchievementRateView.totalCount = CGFloat(goal.entireDetailGoalCnt)
                cell.titleLabel.text = goal.title
                cell.termLabel.text = "\(goal.startDate) - \(goal.endDate)"
            }
            .disposed(by: disposeBag)
        
        // viewModel.storedGoals 데이터가 세팅이 되었을 때 실행됨
        viewModel.isSet
            .subscribe { isSet in
                if isSet {
                    self.updateStorageVisibility()
                }
            }
            .disposed(by: disposeBag)
    }
    
    /// goals의 개수에 따라 보관함의 뷰의 isHidden 상태와 label에 적히는 목표 개수를 업데이트 한다
    private func updateStorageVisibility() {
        [emptyStorageImageView, firstEmptyGuideLabel, secondEmptyGuideLabel]
            .forEach { $0.isHidden = !viewModel.storedGoals.value.isEmpty }
        Logger.debugDescription(viewModel.storedGoals.value)
        storageGoalTableView.isHidden = viewModel.storedGoals.value.isEmpty
        storageGoalTableView.reloadData()
        updateStorageBoxTopLabel()
    }
    
    /// 보관함 맨 위 label에 들어가는 목표 개수 정보와 스타일을 업데이트 해줌
    private func updateStorageBoxTopLabel() {
        let stringValue = "총 \(viewModel.storedGoals.value.count)개의 목표가 보관되어있어요!"
        alertView.label.text = stringValue
        alertView.label.textColor = .black
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColorForText(textForAttribute: "총 \(viewModel.storedGoals.value.count)개의 목표", withColor: .pointPurple)
        alertView.label.attributedText = attributedString
    }
}

extension StorageBoxViewController: UITableViewDelegate {
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
    // 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96 + 16
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 보관함 빈 화면 잘 나오는지 테스트하기 위한 용도입니다!!!
//        goalsValue.remove(at: indexPath.row) // 삭제
//        goals.accept(goalsValue) // 변경된 배열로 업데이트
//        tableView.reloadData() // 테이블뷰 UI 업데이트
        let selectedGoalData = self.viewModel.storedGoals.value[indexPath.row]
        let detailUpperVM = DetailUpperViewModel()
        detailUpperVM.selectedUpperGoal = selectedGoalData
        let detailUpperVC = DetailUpperViewController()
        detailUpperVC.isFromStorage = true
        detailUpperVC.viewModel = detailUpperVM
        push(viewController: detailUpperVC)
    }
}

extension StorageBoxViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !viewModel.storedGoals.value.isEmpty {
            if self.storageGoalTableView.contentOffset.y > (68 + (96 + 16) * 4) {
                if (!viewModel.isLoading) && (!viewModel.isLastPage) {
                    viewModel.retrieveStorageGoalList()
                }
            }
        }
    }
}
