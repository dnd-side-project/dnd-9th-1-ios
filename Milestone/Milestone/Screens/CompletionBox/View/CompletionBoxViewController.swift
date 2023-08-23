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
            $0.backgroundColor = .white
            $0.isHidden = true
            $0.layer.cornerRadius = 20
        }
    
    let headerContainerView = UIView()
    
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
    
    // MARK: - Properties
    
    var viewModel: CompletionViewModel!
    var bubbleKey = UserDefaultsKeyStyle.bubbleInCompletionBox.rawValue
    
    let dateFormatter = DateFormatter()
        .then {
            $0.dateFormat = "yyyy.MM.dd"
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
        viewModel.retrieveGoalData()
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
        viewModel.goalData
            .bind(to: tableView.rx.items(cellIdentifier: CompletionTableViewCell.identifier, cellType: CompletionTableViewCell.self)) { [unowned self] row, element, cell in
                let startDate = dateFormatter.date(from: element.startDate)!
                let endDate = dateFormatter.date(from: element.endDate)!
                cell.dateLabel.text = dateFormatter.string(from: startDate) + " - " + dateFormatter.string(from: endDate)
                cell.label.text = element.title
                cell.completionImageView.image = UIImage(named: RewardToImage(rawValue: element.reward)!.rawValue)
                
                if element.hasRetrospect {
                    cell.button.buttonComponentStyle = .secondary_m_line
                    cell.button.buttonState = .original
                } else {
                    cell.button.buttonComponentStyle = .secondary_m
                    cell.button.buttonState = .original
                    
                    cell.button.rx.tap
                        .subscribe(onNext: {
                            let reviewVC = CompletionReviewViewController()
                            reviewVC.goalIndex = row
                            reviewVC.viewModel = self.viewModel
                            self.push(viewController: reviewVC)
                        })
                        .disposed(by: disposeBag)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.goalDataCount
            .map { count -> NSAttributedString in
                
                let stringValue = "총 \(count)개의 목표가 보관되어있어요!"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
                attributedString.setColorForText(textForAttribute: "총 \(count)개의 목표", withColor: .pointPurple)
                return attributedString
            }
            .bind(to: alertBox.label.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.goalDataCount
            .map { $0 == 0 }
            .bind(to: alertBox.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .asDriver()
            .drive(onNext: { [weak self] loading in
                self?.loading(loading: loading)
            })
            .disposed(by: disposeBag)
        
        viewModel.goalDataCount
            .map { $0 > 0}
            .bind(to: emptyImageView.rx.isHidden, label.rx.isHidden)
            .disposed(by: disposeBag)
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

// MARK: - RxTableViewSectionedAnimatedDataSource

extension CompletionBoxViewController {
    
}
