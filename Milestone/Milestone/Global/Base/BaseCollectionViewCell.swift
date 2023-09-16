//
//  BaseCollectionViewCell.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/06.
//

import UIKit

import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        // Override Layout
    }
    
    func configUI() {
        // View Configuration
    }
    
    func bind() {
        // rx
    }
}
