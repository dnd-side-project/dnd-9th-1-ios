//
//  BaseTableViewCell.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/06.
//

import UIKit

import RxSwift

class BaseTableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        // Override ConfigUI
    }
    
    func bind() {
        // rx
    }
}
