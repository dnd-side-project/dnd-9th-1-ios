//
//  DetailGoalCollectionViewCell.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/12.
//

import UIKit

import RxSwift
import RxCocoa

class DetailGoalCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Subviews
    
    lazy var containerView = UIView()
        .then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 30
        }
    
    lazy var stoneImageView = UIImageView()
    
    lazy var titleLabel = UILabel()
        .then {
            $0.numberOfLines = 2
            $0.font = .pretendard(.semibold, ofSize: 14)
            $0.textAlignment = .center
        }
    
    // MARK: - Properties
    
    static let identifier = "DetailGoalCell"
    
    let cellWidth = (UIScreen.main.bounds.width - 48 - 16) / 3
    var index = 0 // 셀 인덱스
    var isGoalSet = BehaviorRelay(value: false) // 목표가 설정되어 있는지 안 되어 있는지
    let stoneImageArray = [ImageLiteral.imgDetailStoneVer1, ImageLiteral.imgDetailStoneVer2, ImageLiteral.imgDetailStoneVer3,
                           ImageLiteral.imgDetailStoneVer4, ImageLiteral.imgDetailStoneVer5, ImageLiteral.imgDetailStoneVer6,
                           ImageLiteral.imgDetailStoneVer7, ImageLiteral.imgDetailStoneVer8, ImageLiteral.imgDetailStoneVer9]
    
    // MARK: - Functions
    
    override func prepareForReuse() {
        self.titleLabel.text = ""
        self.stoneImageView.image = UIImage()
    }
    
    override func configUI() {
        self.backgroundColor = .gray01
        
        // 그림자 설정
        self.containerView.layer.shadowColor = UIColor.init(hex: "#DCDCDC").cgColor
        self.containerView.layer.shadowOpacity = 1.0
        self.containerView.layer.shadowOffset = CGSize.zero
        self.containerView.layer.shadowRadius = 7 / 2.0
    }
    
    override func render() {
        contentView.addSubview(containerView)
        containerView.addSubViews([stoneImageView, titleLabel])
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.left.right.equalToSuperview().inset(4)
            make.width.equalTo(cellWidth)
            make.height.equalTo(148)
        }
        
        stoneImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(57)
            make.height.equalTo(61)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stoneImageView.snp.bottom).offset(15)
            $0.left.right.equalToSuperview().inset(8)
        }
    }
    
    override func bind() {
        isGoalSet
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isGoalSet in
                guard let self = self else { return }
                self.titleLabel.text = isGoalSet ? "해커스 1000 LC 2 풀기" : "세부 목표를 추가해주세요!"
                self.titleLabel.textColor = isGoalSet ? .gray05 : .gray02
                self.stoneImageView.image = isGoalSet ? self.stoneImageArray[self.index] : ImageLiteral.imgAddStone
            })
            .disposed(by: disposeBag)
    }
    
    /// 셀 내용 업데이트
    func update(content: DetailGoal, index: Int) {
        if let goalTitle = content.goalTitle {
            titleLabel.rx.text.onNext(goalTitle)
        }
        stoneImageView.rx.image.onNext(stoneImageArray[index])
        isGoalSet.accept(content.isGoalSet!)
    }
}
