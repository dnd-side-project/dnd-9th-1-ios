//
//  CompletionBoxViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/11.
//

import UIKit

import RxDataSources
import RxSwift
import RxCocoa
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
            $0.backgroundColor = .white
            $0.isHidden = true
            $0.layer.cornerRadius = 20
        }
    
    let headerContainerView = UIView()
    
    private let tableView = UITableView()
        .then {
            $0.showsVerticalScrollIndicator = false
            $0.delaysContentTouches = false
            $0.separatorStyle = .none
            $0.backgroundColor = .clear
            $0.register(cell: CompletionTableViewCell.self, forCellReuseIdentifier: CompletionTableViewCell.identifier)
        }
    
    private let bubbleView = BubbleView()
        .then {
            $0.guideLabel.text = "이룬 목표에 대한 회고를 자세히 기록해보세요!"
        }
    
    lazy var networkFailView = NetworkFailView()
    
    // MARK: - Properties
    
    var viewModel: CompletionViewModel! = CompletionViewModel()
    var bubbleKey = UserDefaultsKeyStyle.bubbleInCompletionBox.rawValue
    var pushViewDisposables: [Disposable] = []
    
    let viewDidAppearTrigger = PublishSubject<Void>()
    let retrieveNextPageTrigger = PublishSubject<Void>()
    let viewPushDirection = BehaviorRelay<ViewDireciton>(value: .idle)
    
    let dateFormatter = DateFormatter()
        .then {
            $0.dateFormat = "yyyy.MM.dd"
        }
    
    enum ViewDireciton {
        case push
        case pop
        case idle
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테이블뷰 델리게이트 nil 설정을 Then에서 하면 에러 발생하여 우선 이쪽에 표기해두었어요 🥲
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        checkFirstCompletionBox()
        
        viewDidAppearTrigger.onNext(())
        tableView.rx.contentOffset
            .subscribe(onNext: { [unowned self] in
                if $0.y > 0 && $0.y > self.tableView.contentSize.height - self.tableView.frame.size.height - 100 && !self.viewModel.isLoading && !self.viewModel.isLastPage {
                    self.retrieveNextPageTrigger.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - viewdidappear가 push될때 트리거됨
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewPushDirection.value == .idle {
            viewDidAppearTrigger.onNext(())
        }
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
    }
    
    func bindViewModel() {
        // MARK: - 리팩토링 코드
        let input = CompletionViewModel.Input(viewDidAppear: viewDidAppearTrigger, selection: tableView.rx.modelSelected(CompletionTableViewCellViewModel.self).asDriver(), retrieveNextPageTrigger: retrieveNextPageTrigger.asObservable())
        let output = viewModel.transform(input: input)
        
        // 1. 회고 작성가능 갯수 카운트 레이블 바인딩
        
        output.retrospectCount
            .map { count -> NSAttributedString in
                let stringValue = "총 \(count)개의 목표 회고를 작성할 수 있어요!"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
                attributedString.setColorForText(textForAttribute: "총 \(count)개의 목표 회고", withColor: .pointPurple)
                return attributedString
            }
            .bind(to: alertBox.label.rx.attributedText)
            .disposed(by: disposeBag)
        
        output.isAlertBoxHidden
            .bind(to: alertBox.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isAlertBoxHidden.map { !$0 }
            .bind(to: emptyImageView.rx.isHidden, label.rx.isHidden)
            .disposed(by: disposeBag)
    
        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: CompletionTableViewCell.identifier, cellType: CompletionTableViewCell.self)) { _, viewModel, cell in
                cell.bind(to: viewModel)
            }
            .disposed(by: disposeBag)
        
        // MARK: - 분기처리
        output.retrospectSelected.drive(onNext: { [unowned self] in
            if $0.upperGoal.value.hasRetrospect {
                // 회고 데이터랑 같이 푸시
                self.viewPushDirection.accept(.push)
                self.pushRetrospectViewer(goalId: $0.upperGoal.value.goalId, upperGoal: $0.upperGoal.value)
            } else {
                self.viewPushDirection.accept(.push)
                let retrospectVC = RetrospectDetailViewController(viewModel: $0)
                self.push(viewController: retrospectVC)
            }
        })
        .disposed(by: disposeBag)
        
        // MARK: - 완료함의 네트워크 상태에 따라 다른 뷰를 띄워줌
        networkMonitor.isConnected
            .subscribe(onNext: { [weak self] isConnected in
                DispatchQueue.main.async {
                    // isConnected 값이 바뀔 때마다 실행하고자 하는 함수를 호출
                    if isConnected {
                        self?.showCompletionBoxList()
                    } else {
                        self?.showNetworkFailView()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func pushRetrospectViewer(goalId: Int, upperGoal: UpperGoal) {
        viewModel.retrieveRetrospect(goalId: goalId).asObservable()
            .subscribe(onNext: { [unowned self] in
                
                let retrospect = Retrospect(hasGuide: $0.data.hasGuide, contents: $0.data.contents, successLevel: $0.data.successLevel)
               
                if $0.data.hasGuide {
                    let vm = RetrospectViewerWithGuideViewModel(retrospect: retrospect, upperGoal: upperGoal)
                    let viewerVC = RetrospectViewerWithGuideViewController(viewModel: vm)
                    self.push(viewController: viewerVC)
                } else {
                    let vm = RetrospectViewerWithoutGuideViewModel(retrospect: retrospect, upperGoal: upperGoal)
                    let viewerVC = RetrospectViewerWithoutGuideViewController(viewModel: vm)
                    self.push(viewController: viewerVC)
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 네트워크 연결 실패 뷰 띄우기
    private func showNetworkFailView() {
        [emptyImageView, label, tableView]
            .forEach { $0.removeFromSuperview() }
        view.addSubview(networkFailView)
        networkFailView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(84)
        }
    }
    
    /// 네트워크 연결 성공이면 완료함 원래 뷰들 띄우기
    private func showCompletionBoxList() {
        networkFailView.removeFromSuperview()
        render()
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
        }
    }
}

// MARK: - UITableViewDelegate

extension CompletionBoxViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 + 16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerContainerView.addSubview(alertBox)
        
        alertBox.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(4)
            make.height.equalTo(60)
        }
    
        return headerContainerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60 + 8
    }
}
