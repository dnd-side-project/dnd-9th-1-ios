//
//  LowerGoalTableViewCell.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/13.
//

import UIKit

import RxCocoa
import RxSwift

// MARK: - 하위 목표 체크 리스트 테이블뷰

class LowerGoalTableViewCell: BaseTableViewCell {
    
    // MARK: - Subviews
    
    lazy var containerView = UIView()
        .then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 56 / 2
        }
    lazy var checkImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgWhiteCheck
        }
    lazy var titleLabel = UILabel()
        .then {
            $0.numberOfLines = 2
            $0.font = .pretendard(.semibold, ofSize: 16)
            $0.textAlignment = .left
        }
    lazy var blurryView = UIView()
        .then {
            $0.backgroundColor = .white.withAlphaComponent(0.6)
            $0.layer.cornerRadius = 56 / 2
        }
    
    // MARK: - Properties
    
    static let identifier = "LowerGoalTableViewCell"
    var isCompleted = BehaviorRelay(value: false) // 목표가 완료되었는지 아닌지
    
    // MARK: - Functions
    
    override func prepareForReuse() {
        self.titleLabel.text = ""
        self.checkImageView.image = UIImage()
        self.containerView.backgroundColor = .white
    }
    
    override func configUI() {
        self.backgroundColor = .gray01
        self.selectionStyle = .none
        
        // 그림자 설정
        self.containerView.layer.shadowColor = UIColor.init(hex: "#DCDCDC").cgColor
        self.containerView.layer.shadowOpacity = 1.0
        self.containerView.layer.shadowOffset = CGSize.zero
        self.containerView.layer.shadowRadius = 7 / 2.0
    }
    
    override func render() {
        contentView.addSubview(containerView)
        containerView.addSubViews([checkImageView, titleLabel])
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
            make.height.equalTo(56)
        }
        checkImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(checkImageView.snp.right).offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    /// 보관함일 때 셀을 흐리게 설정
    func makeCellBlurry() {
        containerView.addSubView(blurryView)
        blurryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func bindUI() {
        isCompleted
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isCompleted in
                guard let self = self else { return }
                self.containerView.backgroundColor = isCompleted ? .secondary03 : .white
                self.titleLabel.textColor = isCompleted ? .primary : .black
                self.checkImageView.image = isCompleted ? ImageLiteral.imgBlueCheck : ImageLiteral.imgWhiteCheck
            })
            .disposed(by: disposeBag)
    }
    
    /// 셀 내용 업데이트
    func update(content: LowerGoal) {
        titleLabel.rx.text.onNext(content.title)
        isCompleted.accept(content.isCompleted)
    }
}
