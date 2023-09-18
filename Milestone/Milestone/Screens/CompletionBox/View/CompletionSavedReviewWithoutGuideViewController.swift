//
//  CompletionSavedReviewWithoutGuideViewController.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/17.
//

import UIKit

class CompletionSavedReviewWithoutGuideViewController: BaseViewController, ViewModelBindableType {

    // MARK: Subviews
    
    lazy var leftBarButton = DefaultLeftBarButton()
        .then {
            $0.target = self
            $0.action = #selector(pop)
        }
    
    let titleBox = UIView()
        .then {
            $0.backgroundColor = .init(hex: "#F3F3FF")
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
    
    let textView = UITextView()
        .then {
            $0.backgroundColor = .init(hex: "#F3F3FF")
            $0.isScrollEnabled = false
            $0.isEditable = false
            $0.textContainerInset = UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 24)
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
    
    let fillImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgRetrospectView1
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
        
        scrollView.subviews.first!.addSubViews([textView, fillImageView])
        
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
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }

        fillImageView.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(24)
            make.centerX.equalTo(scrollView)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(fillImageView.snp.width)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-1)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).priority(.low)
        }
    }
    
    override func configUI() {
        view.backgroundColor = .init(hex: "#F3F3FF")
        
        textView.text = ""
        
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
        
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func bindViewModel() {
        let goalDataAtIndex = viewModel.retrieveGoalDataAtIndex(index: goalIndex)
        
        let startDate = dateFormatter.date(from: goalDataAtIndex.startDate)!
        let endDate = dateFormatter.date(from: goalDataAtIndex.endDate)!
        
        titleLabel.text = goalDataAtIndex.title
        dateLabel.text = "\(dateFormatter.string(from: startDate))" + " - " + "\(dateFormatter.string(from: endDate))"
        
        viewModel.retrieveRetrospectWithId(goalId: goalDataAtIndex.goalId)
        
        viewModel.retrospect
            .subscribe(onNext: { [unowned self] retro in
                self.textView.text = retro.contents["NONE"]
                self.fillImageView.image = UIImage(named: retro.successLevel)
            })
            .disposed(by: disposeBag)
    }
}
