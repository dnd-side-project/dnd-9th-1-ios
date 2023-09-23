//
//  DetailGoalCollectionViewCell.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/12.
//

import UIKit

import RxCocoa
import RxSwift

// MARK: - 하위 목표 컬렉션 뷰

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
            $0.textColor = .gray05
            $0.textAlignment = .center
        }
    lazy var blurryView = UIView()
        .then {
            $0.backgroundColor = .white.withAlphaComponent(0.6)
            $0.layer.cornerRadius = 30
        }
    
    // MARK: - Properties
    
    static let identifier = "DetailGoalCollectionViewCell"
    
    var index = 0 // 셀 인덱스
    var isSet = BehaviorRelay(value: false) // 목표가 설정되어 있는지 안 되어 있는지
    var isCompleted = BehaviorRelay(value: false) // 목표가 설정되어 있는지 안 되어 있는지
    
    // MARK: - Functions
    
    override func prepareForReuse() {
        self.titleLabel.text = ""
        self.titleLabel.textColor = .gray05
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
   
    func makeCellBlurry() {
        containerView.addSubView(blurryView)
        blurryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
