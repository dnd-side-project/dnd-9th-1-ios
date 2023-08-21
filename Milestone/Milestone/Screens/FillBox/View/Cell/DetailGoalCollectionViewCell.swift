//
//  DetailGoalCollectionViewCell.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/12.
//

import UIKit

import RxCocoa
import RxSwift

// MARK: - 세부 목표 컬렉션 뷰

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
    
    static let identifier = "DetailGoalCollectionViewCell"
    
    var index = 0 // 셀 인덱스
    var isSet = BehaviorRelay(value: false) // 목표가 설정되어 있는지 안 되어 있는지
    var isCompleted = BehaviorRelay(value: false) // 목표가 설정되어 있는지 안 되어 있는지
    let stoneImageArray = [ImageLiteral.imgDetailStoneVer1, ImageLiteral.imgDetailStoneVer2, ImageLiteral.imgDetailStoneVer3,
                           ImageLiteral.imgDetailStoneVer4, ImageLiteral.imgDetailStoneVer5, ImageLiteral.imgDetailStoneVer6,
                           ImageLiteral.imgDetailStoneVer7, ImageLiteral.imgDetailStoneVer8, ImageLiteral.imgDetailStoneVer9]
    let completedImageArray = [ImageLiteral.imgCompletedStoneVer1, ImageLiteral.imgCompletedStoneVer2, ImageLiteral.imgCompletedStoneVer3,
                           ImageLiteral.imgCompletedStoneVer4, ImageLiteral.imgCompletedStoneVer5, ImageLiteral.imgCompletedStoneVer6,
                           ImageLiteral.imgCompletedStoneVer7, ImageLiteral.imgCompletedStoneVer8, ImageLiteral.imgCompletedStoneVer9]
    
    // MARK: - Functions
    
    override func prepareForReuse() {
        self.titleLabel.text = ""
        self.stoneImageView.image = UIImage()
    }
    
    override func render() {
        contentView.addSubview(containerView)
        containerView.addSubViews([stoneImageView, titleLabel])
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        stoneImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(57)
            make.height.equalTo(61)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(stoneImageView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(8)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .gray01
        
        // 그림자 설정
        self.containerView.layer.shadowColor = UIColor.init(hex: "#DCDCDC").cgColor
        self.containerView.layer.shadowOpacity = 1.0
        self.containerView.layer.shadowOffset = CGSize.zero
        self.containerView.layer.shadowRadius = 7 / 2.0
    }
    
    override func bind() {
        isSet
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isSet in
                guard let self = self else { return }
                if self.titleLabel.text?.isEmpty ?? true { self.titleLabel.text = "세부 목표를 추가해주세요!" }
                self.titleLabel.textColor = isSet ? .gray05 : .gray02
                if !isSet { self.stoneImageView.image = ImageLiteral.imgAddStone }
            })
            .disposed(by: disposeBag)
        
        // 완료되었으면 깨진 돌 이미지로 설정
        isCompleted
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isCompleted in
                guard let self = self else { return }
                self.stoneImageView.image = isCompleted ? self.completedImageArray[self.index] : self.stoneImageArray[self.index]
            })
            .disposed(by: disposeBag)
    }
    
    /// 셀 내용 업데이트
    func update(content: DetailGoalTemp, index: Int) {
        self.index = index
        titleLabel.rx.text.onNext(content.title)
        isSet.accept(content.isSet)
        if content.isSet { // 세팅되지 않은 값은 완료를 고려 안함
            isCompleted.accept(content.isCompleted)
        }
    }
}
