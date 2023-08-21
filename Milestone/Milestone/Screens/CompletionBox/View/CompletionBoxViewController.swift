//
//  CompletionBoxViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/11.
//

import UIKit

import RxDataSources
import RxSwift
import SnapKit
import Then

class CompletionBoxViewController: BaseViewController, ViewModelBindableType {
    
    // MARK: - Subviews
    
    private let emptyImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgcompletionEmpty
            $0.contentMode = .scaleAspectFit
        }
    
    private let label = UILabel()
        .then {
            $0.text = "완료한 목표들이 채워질 예정이예요!\n완료함을 차곡차곡 쌓아볼까요?"
            $0.numberOfLines = 0
            $0.textColor = .gray02
            $0.font = UIFont.pretendard(.semibold, ofSize: 18)
            $0.setLineSpacing(lineHeightMultiple: 1.3)
            $0.textAlignment = .center
        }
    
    private let alertBox = CompletionAlertView()
        .then {
            $0.isHidden = true
            $0.layer.cornerRadius = 20
        }
    
    private let tableView = UITableView()
        .then {
            $0.delaysContentTouches = false
            $0.separatorStyle = .none
            $0.backgroundColor = .clear
            $0.register(cell: CompletionTableViewCell.self, forCellReuseIdentifier: CompletionTableViewCell.identifier)
        }
    
    private let bubbleView = BubbleView()
        .then {
            $0.guideLabel.text = "이룬 목표에 대한 회고를 자세히 기록해보세요!"
        }
    
    var tapDisposable: [Disposable] = []
    var cellHideDisposable: Disposable?
    var nsAttributedStringDisposable: Disposable?
    var tableViewScrollDisposable: Disposable?
    
    // MARK: - Properties
    
    var viewModel: CompletionViewModel!
    var bubbleKey = UserDefaultsKeyStyle.bubbleInCompletionBox.rawValue
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테이블뷰 델리게이트 nil 설정을 Then에서 하면 에러 발생하여 우선 이쪽에 표기해두었어요 🥲
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        checkFirstCompletionBox()
    }
    
    /// 뷰 사라질때 등록해둔 구독자들을 클래스 속성에 추가한 뒤 viewWillDisappear에서 커스텀 디스포즈
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.layoutIfNeeded()
        guard let cell = tableView.visibleCells.first else { return }
        let alertView = cell.contentView.subviews.last as! CompletionAlertView

        cellHideDisposable = viewModel.completionList
            .map { $0.isEmpty }
            .bind(to: cell.rx.isHidden)

        nsAttributedStringDisposable = viewModel.completionList
            .map {
                let string = NSMutableAttributedString(string: "총 \($0.count - 1)개의 목표 회고를 작성할 수 있어요!")
                string.setColorForText(textForAttribute: "총 \($0.count - 1)개의 목표 회고", withColor: .pointPurple)
                return string
            }
            .bind(to: alertView.label.rx.attributedText)

        tableView.visibleCells.enumerated().forEach { index, cell in
            guard let cell = cell as? CompletionTableViewCell else { return }
            tapDisposable.append(cell.button.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    
                    self.viewModel.goalObservable
                        .element(at: index)
                        .subscribe(onNext: {
                            
                            if $0.isCompleted {
                                switch $0.style {
                                case .guide:
                                    var savedReviewViewWithGuide = CompletionSavedReviewWithGuideViewController()
                                    savedReviewViewWithGuide.goalIndex = index
                                    savedReviewViewWithGuide.bind(viewModel: self.viewModel)
                                    self.push(viewController: savedReviewViewWithGuide)
                                case .free:
                                    var savedReviewViewWithoutGuide = CompletionSavedReviewWithoutGuideViewController()
                                    savedReviewViewWithoutGuide.goalIndex = index
                                    savedReviewViewWithoutGuide.bind(viewModel: self.viewModel)
                                    self.push(viewController: savedReviewViewWithoutGuide)
                                }
                            } else {
                                var reviewVC = CompletionReviewViewController()
                                reviewVC.goalIndex = index
                                reviewVC.bind(viewModel: self.viewModel)
                                self.push(viewController: reviewVC)
                            }
                        })
                        .disposed(by: self.disposeBag)
                }))
        }

        setAdditionalLayout()
    }
    
    /// 뷰 전환에 따른 Dispose 커스텀 로직
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tapDisposable.forEach { disposable in
            disposable.dispose()
        }
        tapDisposable = []
        
        cellHideDisposable?.dispose()
        nsAttributedStringDisposable?.dispose()
    }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([emptyImageView, label, tableView])
        
        emptyImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(24)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
    
    override func configUI() {
        view.backgroundColor = .gray01
        
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.completionList
            .bind(to: tableView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
        viewModel.completionList
            .map { !$0.isEmpty }
            .bind(to: emptyImageView.rx.isHidden, label.rx.isHidden)
            .disposed(by: disposeBag)
        
        tableViewScrollDisposable = tableView.rx.didScroll
            .subscribe { [weak self] _ in
                self?.bubbleView.isHidden = true
            }
    }
    
    /// 테이블뷰 레이아웃 세팅 완료 후 정의해야할 레이아웃 대상들을 분리
    func setAdditionalLayout() {
        view.addSubview(bubbleView)
        bubbleView.snp.makeConstraints { make in
            make.top.equalTo(tableView.visibleCells[1].snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.trailing.equalToSuperview().offset(-54)
            make.leading.equalToSuperview().offset(54)
            make.height.equalTo(45)
        }
    }
    
    /// 처음이 맞는지 확인 -> 맞으면 말풍선 뷰 띄우기
    private func checkFirstCompletionBox() {
        if !UserDefaults.standard.bool(forKey: bubbleKey) {
            bubbleView.isHidden = false
            UserDefaults.standard.set(true, forKey: bubbleKey)
        } else {
            bubbleView.isHidden = true
            tableViewScrollDisposable?.dispose()
        }
    }
}

// MARK: - UITableViewDelegate

extension CompletionBoxViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        }
        return 150
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

// MARK: - RxTableViewSectionedAnimatedDataSource

extension CompletionBoxViewController {
    private func dataSource() -> RxTableViewSectionedAnimatedDataSource<CompletionSectionModel> {
        return RxTableViewSectionedAnimatedDataSource<CompletionSectionModel> { dataSource, tableView, indexPath, goal in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CompletionTableViewCell.identifier, for: indexPath) as? CompletionTableViewCell else { return UITableViewCell() }
            
            if indexPath.section == 0 {
                let completionView = CompletionAlertView()
                
                cell.contentView.addSubview(completionView)
                completionView.snp.makeConstraints { make in
                    make.margins.equalTo(cell.contentView.snp.margins)
                }
                cell.calendarImageView.isHidden = true
                cell.button.isHidden = true
                cell.completionImageView.isHidden = true
                cell.dateLabel.isHidden = true
                cell.label.isHidden = true
                
                return cell
            }
            
            cell.label.text = goal.title
            
            let dateFormatter = DateFormatter().then { $0.dateFormat = "yyyy.MM.dd" }
            let startDateString = dateFormatter.string(from: goal.startDate)
            let endDateString = dateFormatter.string(from: goal.endDate)
            
            cell.dateLabel.text = startDateString + " - " + endDateString
            
            if goal.isCompleted {
                cell.button.setTitle("회고 보기", for: .normal)
                cell.button.setTitleColor(.primary, for: .normal)
                cell.button.backgroundColor = .white
                cell.button.layer.borderColor = UIColor.secondary01.cgColor
                cell.button.layer.borderWidth = 1
            } else {
                cell.button.setTitle("회고 작성하기", for: .normal)
                cell.button.setTitleColor(.primary, for: .normal)
                cell.backgroundColor = .secondary03
                cell.layer.borderColor = UIColor.clear.cgColor
            }
            
            return cell
        }
        
    }
}
