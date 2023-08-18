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
            $0.image = ImageLiteral.imgPlaceholder
        }
    
    // MARK: Properties
    
    var goalIndex: Int!
    var viewModel: CompletionViewModel!
    
    let dateFormatter = DateFormatter()
        .then {
            $0.dateFormat = "yyyy.MM.dd"
        }
    
    enum IndexText: String {
        case first = "좋았던 점은 무엇인가요?"
        case second = "아쉬웠던 점이나, 부족했던 점은 무엇인가요?"
        case third = "배운 점은 무엇인가요?"
        case fourth = "목표를 통해 뭘 얻고자 하셨나요?"
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
            make.top.equalTo(firstQuestionView.snp.bottom).offset(24)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.height.equalTo(260)
        }
        
        thirdQuestionView.snp.makeConstraints { make in
            make.top.equalTo(secondQuestionView.snp.bottom).offset(24)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.height.equalTo(260)
        }
        
        fourthQuestionView.snp.makeConstraints { make in
            make.top.equalTo(thirdQuestionView.snp.bottom).offset(24)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.height.equalTo(260)
        }
        
        fillLabel.snp.makeConstraints { make in
            make.top.equalTo(fourthQuestionView.snp.bottom).offset(32)
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
        setAttributedIndexLabel()
        
        navigationItem.leftBarButtonItem = leftBarButton
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
            .flatMap { Observable.from($0.contents.enumerated()) }
            .subscribe(onNext: { [unowned self] in
                switch $0.offset {
                case 0:
                    
                    self.firstQuestionView.textView.text = $0.element
                case 1:
                    self.secondQuestionView.textView.text = $0.element
                case 2:
                    self.thirdQuestionView.textView.text = $0.element
                case 3:
                    self.fourthQuestionView.textView.text = $0.element
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
            
        scrollView.rx.didScroll
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                if self.scrollView.contentOffset.y <= 0 {
                    self.titleBox.makeShadow(alpha: 0, x: 0, y: 0, blur: 0, spread: 0)
                } else {
                    self.titleBox.makeShadow(color: .init(hex: "#464646", alpha: 0.1), alpha: 1, x: 0, y: 10, blur: 10, spread: 0)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setAttributedIndexLabel() {
        setAttributedText(originString: .first, targetView: firstQuestionView, "좋았던 점")
        setAttributedText(originString: .second, targetView: secondQuestionView, "아쉬웠던 점", "부족했던 점")
        setAttributedText(originString: .third, targetView: thirdQuestionView, "배운 점")
        setAttributedText(originString: .fourth, targetView: fourthQuestionView, "얻고자")
    }
    
    func setAttributedText(originString: IndexText, targetView: IndexViewAfterSaved, _ targetText: String...) {
        let attributedText = NSMutableAttributedString(string: originString.rawValue)
        
        for target in targetText {
            attributedText.setColorForText(textForAttribute: target, withColor: .pointPurple)
        }
        
        targetView.indexLabel.attributedText = attributedText
            
    }
    
    // MARK: Objc functions
}
