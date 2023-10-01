//
//  CompletionTableViewCell.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/15.
//

import UIKit

import RxSwift

class CompletionTableViewCell: BaseTableViewCell {
    // MARK: Subviews
    
    let containerView = UIView()
        .then {
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .white
        }
    
    let label = UILabel()
        .then {
            $0.font = UIFont.pretendard(.semibold, ofSize: 18)
            $0.text = "포토샵 자격증 따기"
        }
    
    let completionImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgPlaceholder
        }
     
    let calendarImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgCalendar
        }
    
    let dateLabel = UILabel()
        .then {
            $0.font = UIFont.pretendard(.regular, ofSize: 12)
            $0.textColor = .gray03
        }
    
    let button = RoundedButton(type: .system)
        .then {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20
            $0.setTitleColor(.primary, for: .normal)
            $0.titleLabel?.font = UIFont.pretendard(.semibold, ofSize: 16)
            $0.setTitle("회고 작성하기", for: .normal)
        }
    
    // MARK: Properties
    static let identifier = "CompletionBoxCell"
    var hasRetrospect = false
    
    // MARK: Functions
    func bind(to viewModel: CompletionTableViewCellViewModel) {
        viewModel.title.asDriver().drive(label.rx.text).disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.startDate, viewModel.endDate)
            .map { $0.0 + " - " + $0.1 }
            .asDriver(onErrorJustReturn: "")
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.hasRetrospect.subscribe(onNext: { [unowned self] in
            self.button.buttonComponentStyle = $0 ? .secondary_m_line : .secondary_m
            self.button.buttonState = .original
            self.button.setTitle( $0 ? "회고 보기" : "회고 작성하기", for: .normal)
        }).disposed(by: disposeBag)
        
        viewModel.reward.map {
            UIImage(named: $0)
        }
        .asDriver(onErrorJustReturn: UIImage())
        .drive(completionImageView.rx.image)
        .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func render() {
        contentView.addSubview(containerView)
        containerView.addSubViews([completionImageView, label, calendarImageView, dateLabel, button])
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(4)
        }
        
        completionImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(24)
            make.width.height.equalTo(48)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(completionImageView.snp.top)
            make.leading.equalTo(completionImageView.snp.trailing).offset(16)
        }
        
        calendarImageView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(4)
            make.height.width.equalTo(16)
            make.leading.equalTo(label.snp.leading)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(calendarImageView.snp.trailing).offset(8)
            make.centerY.equalTo(calendarImageView.snp.centerY)
        }
        
        button.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading).offset(24)
            make.trailing.equalTo(containerView.snp.trailing).offset(-24)
            make.height.equalTo(46)
            make.top.equalTo(completionImageView.snp.bottom).offset(16)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .gray01
        self.selectionStyle = .none
        self.containerView.makeShadow(color: .init(hex: "#DCDCDC"), alpha: 1.0, x: 0, y: 0, blur: 7, spread: 0)
    }
}
