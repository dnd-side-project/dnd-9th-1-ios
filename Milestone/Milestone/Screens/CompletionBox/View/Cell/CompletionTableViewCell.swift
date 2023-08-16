//
//  CompletionTableViewCell.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/15.
//

import UIKit

class CompletionTableViewCell: BaseTableViewCell, ViewModelBindableType {
    // MARK: Subviews
    let label = UILabel()
        .then {
            $0.font = UIFont.pretendard(.semibold, ofSize: 18)
            $0.text = "포토샵 자격증 따기"
        }
    
    let completionImageView = UIImageView()
        .then {
            $0.image = #imageLiteral(resourceName: "placeholder")
        }
    
    let calendarImageView = UIImageView()
        .then {
            $0.image = #imageLiteral(resourceName: "calendar")
        }
    
    let dateLabel = UILabel()
        .then {
            $0.font = UIFont.pretendard(.regular, ofSize: 12)
            $0.textColor = .gray03
        }
    
    let button = UIButton(type: .system)
        .then {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20
            $0.setTitleColor(.primary, for: .normal)
            $0.titleLabel?.font = UIFont.pretendard(.semibold, ofSize: 16)
            $0.backgroundColor = .secondary03
            $0.setTitle("회고 작성하기", for: .normal)
        }
    
    // MARK: Properties
    static let identifier = "CompletionBoxCell"
    var viewModel: CompletionViewModel!
    var coordinator = CompletionBoxCoordinator(navigationController: UINavigationController())
    
    // MARK: Functions
    override func render() {
        contentView.addSubViews([completionImageView, label, calendarImageView, dateLabel, button])
        
        completionImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(24)
            make.top.equalTo(contentView.snp.top).offset(24)
            make.width.height.equalTo(48)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(completionImageView.snp.top)
            make.leading.equalTo(completionImageView.snp.trailing).offset(16)
        }
        
        calendarImageView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(4)
            make.leading.equalTo(label.snp.leading)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(calendarImageView.snp.trailing).offset(8)
            make.top.equalTo(calendarImageView.snp.top)
        }
        
        button.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(24)
            make.trailing.equalTo(contentView.snp.trailing).offset(-24)
            make.height.equalTo(46)
            make.top.equalTo(completionImageView.snp.bottom).offset(16)
        }
    }
    
    override func configUI() {
        contentView.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    
    func bindViewModel() {
        
    }
}
