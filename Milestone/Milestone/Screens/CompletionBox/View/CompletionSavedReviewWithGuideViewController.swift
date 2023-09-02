//
//  CompletionSavedReviewViewController.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/17.
//

import UIKit

import RxCocoa
import RxSwift

class CompletionSavedReviewWithGuideViewController: BaseViewController, ViewModelBindableType {
    
    // MARK: Subviews
    
    lazy var leftBarButton = UIBarButtonItem()
        .then {
            $0.image = UIImage(systemName: "chevron.left")
            $0.style = .plain
            $0.tintColor = .gray05
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
    
    let firstQuestionView = IndexViewAfterSaved()
    let secondQuestionView = IndexViewAfterSaved()
    let thirdQuestionView = IndexViewAfterSaved()
    let fourthQuestionView = IndexViewAfterSaved()
    
    let fillLabel = UILabel()
        .then {
            $0.font = .pretendard(.semibold, ofSize: 16)
            $0.text = "마음 채움도"
        }
    
    let fillImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgRetrospectView1
        }
    
    // MARK: Properties
    
    var goalIndex: Int!
    var viewModel: CompletionViewModel!
    
    let dateFormatter = DateFormatter()
        .then {
            $0.dateFormat = "yyyy.MM.dd"
        }
    
    // MARK: Functions
    
    override func render() {
        view.addSubViews([titleBox, scrollView])
        titleBox.addSubViews([titleLabel, calendarImageView, dateLabel])
        
        scrollView.subviews.first!.addSubViews([firstQuestionView, secondQuestionView, thirdQuestionView, fourthQuestionView, fillLabel, fillImageView])
        
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
        
        firstQuestionView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.height.equalTo(260)
        }
        
        secondQuestionView.snp.makeConstraints { make in
            make.top.equalTo(firstQuestionView.textView.snp.bottom).offset(24)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.height.equalTo(260)
        }
        
        thirdQuestionView.snp.makeConstraints { make in
            make.top.equalTo(secondQuestionView.textView.snp.bottom).offset(24)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.height.equalTo(260)
        }
        
        fourthQuestionView.snp.makeConstraints { make in
            make.top.equalTo(thirdQuestionView.textView.snp.bottom).offset(24)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.height.equalTo(260)
        }
        
//        fillLabel.snp.makeConstraints { make in
//            make.top.equalTo(fourthQuestionView.textView.snp.bottom).offset(32)
//            make.leading.equalTo(view.snp.leading).offset(24)
//        }
        
        fillImageView.snp.makeConstraints { make in
            make.top.equalTo(fourthQuestionView.textView.snp.bottom).offset(24)
            make.centerX.equalTo(scrollView)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(fillImageView.snp.width)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-1)
        }
    }
    
    override func configUI() {
        view.backgroundColor = .init(hex: "#F3F3FF")
        setAttributedIndexLabel()
        
        navigationItem.leftBarButtonItem = leftBarButton
        
        firstQuestionView.indexView.image = ImageLiteral.imgGood
        secondQuestionView.indexView.image = ImageLiteral.imgBad
        thirdQuestionView.indexView.image = ImageLiteral.imgBook
        fourthQuestionView.indexView.image = ImageLiteral.imgGift
    }
    
    func bindViewModel() {
        viewModel.retrieveGoalDataAtIndex(index: goalIndex)
            .map { $0.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.retrieveGoalDataAtIndex(index: goalIndex)
            .map { [unowned self] goal -> String in
                let startDate = dateFormatter.date(from: goal.startDate)!
                let endDate = dateFormatter.date(from: goal.endDate)!
                return "\(dateFormatter.string(from: startDate))" + " - " + "\(dateFormatter.string(from: endDate))"
            }
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.retrieveGoalDataAtIndex(index: goalIndex)
            .map { $0.goalId }
            .subscribe(onNext: { [unowned self] in
                self.viewModel.retrieveRetrospectWithId(goalId: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.retrospect
            .subscribe(onNext: { [unowned self] retro in
                self.firstQuestionView.textView.text = retro.contents["LIKED"]
                self.secondQuestionView.textView.text = retro.contents["LACKED"]
                self.thirdQuestionView.textView.text = retro.contents["LEARNED"]
                self.fourthQuestionView.textView.text = retro.contents["LONGED_FOR"]
                
                fillImageView.image = UIImage(named: retro.successLevel)
            })
            .disposed(by: disposeBag)
    }
    
    func setAttributedIndexLabel() {
        setAttributedText(originString: .first, targetView: firstQuestionView, "좋았던 점")
        setAttributedText(originString: .second, targetView: secondQuestionView, "아쉬웠던 점", "부족했던 점")
        setAttributedText(originString: .third, targetView: thirdQuestionView, "배운 점")
        setAttributedText(originString: .fourth, targetView: fourthQuestionView, "얻고자")
    }
    
    func setAttributedText(originString: IndexTextStyle, targetView: IndexViewAfterSaved, _ targetText: String...) {
        let attributedText = NSMutableAttributedString(string: originString.rawValue)
        
        for target in targetText {
            attributedText.setColorForText(textForAttribute: target, withColor: .pointPurple)
        }
        
        targetView.indexLabel.attributedText = attributedText
            
    }
}
