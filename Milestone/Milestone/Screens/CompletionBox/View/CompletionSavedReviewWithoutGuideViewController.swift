//
//  CompletionSavedReviewWithoutGuideViewController.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/17.
//

import UIKit

class CompletionSavedReviewWithoutGuideViewController: BaseViewController, ViewModelBindableType {

    // MARK: Subviews
    let titleBox = UIView()
        .then {
            $0.backgroundColor = .systemBackground
        }

    let titleLabel = UILabel()
        .then {
            $0.font = UIFont.pretendard(.semibold, ofSize: 24)
        }
    
    let calendarImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgCalendar
        }
    
    let dateLabel = UILabel()
        .then {
            $0.textColor = .gray03
            $0.font = UIFont.pretendard(.regular, ofSize: 14)
        }
    
    let textViewWrapper = UIView()
        .then {
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .systemBackground
        }
    
    let textView = UITextView()
        .then {
            $0.isEditable = false
            $0.textContainerInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        }
    
    let scrollView = UIScrollView()
        .then { sv in
            let view = UIView()
            sv.addSubview(view)
            view.snp.makeConstraints {
                $0.top.equalTo(sv.contentLayoutGuide.snp.top)
                $0.leading.equalTo(sv.contentLayoutGuide.snp.leading)
                $0.trailing.equalTo(sv.contentLayoutGuide.snp.trailing)
                $0.bottom.equalTo(sv.contentLayoutGuide.snp.bottom)

                $0.leading.equalTo(sv.frameLayoutGuide.snp.leading)
                $0.trailing.equalTo(sv.frameLayoutGuide.snp.trailing)
                $0.height.equalTo(sv.frameLayoutGuide.snp.height).priority(.low)
            }
        }
    
    let fillLabel = UILabel()
        .then {
            $0.font = .pretendard(.semibold, ofSize: 16)
            $0.text = "마음 채움도"
        }
    
    let fillImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgPlaceholder
        }
    
    // MARK: Properties
    var viewModel: CompletionViewModel!
    var goalIndex: Int!
    
    let dateFormatter = DateFormatter()
        .then {
            $0.dateFormat = "yyyy.MM.dd"
        }
    
    // MARK: Life Cycles
    
    // MARK: Functions
    override func render() {
        view.addSubViews([titleBox, scrollView])
        titleBox.addSubViews([titleLabel, calendarImageView, dateLabel])
        
        scrollView.subviews.first!.addSubViews([textViewWrapper, textView, fillLabel, fillImageView])
        
        titleBox.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(90)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleBox.snp.leading).offset(24)
            make.top.equalTo(titleBox.snp.top).offset(16)
        }
        
        calendarImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(calendarImageView.snp.trailing).offset(8)
            make.centerY.equalTo(calendarImageView.snp.centerY)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleBox.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        textViewWrapper.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(2)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(320)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(textViewWrapper.snp.top)
            make.leading.equalTo(textViewWrapper.snp.leading).offset(24)
            make.trailing.equalTo(textViewWrapper.snp.trailing).offset(-24)
            make.bottom.equalTo(textViewWrapper.snp.bottom).offset(-48)
        }
        
        fillLabel.snp.makeConstraints { make in
            make.top.equalTo(textViewWrapper.snp.bottom).offset(32)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
        
        fillImageView.snp.makeConstraints { make in
            make.top.equalTo(fillLabel.snp.bottom).offset(24)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(190)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-16)
        }
    }
    
    override func configUI() {
        view.backgroundColor = .systemBackground
        
        textView.rx.text
            .compactMap { $0 }
            .map { str -> NSAttributedString in
                let style = NSMutableParagraphStyle()
                style.lineHeightMultiple = 1.5
                let attributes = [NSMutableAttributedString.Key.paragraphStyle: style, NSMutableAttributedString.Key.font: UIFont.pretendard(.regular, ofSize: 14), NSMutableAttributedString.Key.foregroundColor: UIColor.black]
                return NSAttributedString(string: str, attributes: attributes)
            }
            .bind(to: textView.rx.attributedText)
            .disposed(by: disposeBag)
        
        textViewWrapper.makeShadow(color: .init(hex: "#DCDCDC"), alpha: 1, x: 0, y: 0, blur: 7, spread: 0)

    }
    
    func bindViewModel() {
        viewModel.goalObservable
            .element(at: goalIndex)
            .map { $0.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.goalObservable
            .element(at: goalIndex)
            .map { [unowned self] goal -> String in
                return "\(self.dateFormatter.string(from: goal.startDate))" + " - " + "\(self.dateFormatter.string(from: goal.endDate))"
            }
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.goalObservable
            .element(at: goalIndex)
            .map { $0.contents.first ?? "" }
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: Objc functions
    
}
