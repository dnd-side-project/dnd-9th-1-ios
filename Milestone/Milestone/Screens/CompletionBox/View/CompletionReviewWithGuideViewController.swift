//
//  CompletionReviewWithGuideViewController.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/16.
//

import UIKit
import RxCocoa
import RxSwift

class CompletionReviewWithGuideViewController: BaseViewController {
    
    // MARK: Subviews
    
    let firstQuestionView = IndexView()
    let secondQuestionView = IndexView()
    let thirdQuestionView = IndexView()
    let fourthQuestionView = IndexView()
    
    let fillLabel = UILabel()
        .then {
            $0.font = UIFont.pretendard(.semibold, ofSize: 16)
            $0.text = "마음 채움도"
        }
    
    let fillInformationLabel = UILabel()
        .then {
            $0.textColor = .gray03
            $0.font = UIFont.pretendard(.regular, ofSize: 12)
            $0.text = "이 목표를 이뤄낸 것이 얼마나 도움됐나요?"
        }
    
    let lowestPointView = PointView()
    let lowerPointView = PointView()
    let middlePointView = PointView()
    let higherPointView = PointView()
    let highestPointView = PointView()
    
    private lazy var fillPointStackView = UIStackView(arrangedSubviews: [self.lowestPointView, self.lowerPointView, self.middlePointView, self.higherPointView, self.highestPointView])
        .then {
            $0.distribution = .equalSpacing
            $0.spacing = 6
            $0.axis = .horizontal
        }
    
    let registerButton = UIButton(type: .system)
        .then {
            $0.titleLabel?.font = .pretendard(.semibold, ofSize: 16)
            $0.layer.cornerRadius = 20
            $0.isEnabled = false
            $0.setTitleColor(.white, for: .normal)
            $0.setTitle("회고 작성 완료", for: .normal)
            
            $0.setTitleColor(.gray01, for: .disabled)
            $0.setTitle("회고 작성 완료", for: .disabled)
            $0.backgroundColor = UIColor(hex: "#ADBED6")
        }
    
    // MARK: Properties
    
    private var fillSelected = PublishSubject<Bool>()
    
    // MARK: Life Cycles
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async { [weak self] in
            self?.render()
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }
        
     }
    
    // MARK: Functions
    
    override func render() {
        view.addSubViews([firstQuestionView, secondQuestionView, thirdQuestionView, fourthQuestionView, fillLabel, fillInformationLabel, fillPointStackView, registerButton])
        
        firstQuestionView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.snp.top)
            make.height.equalTo(260)
        }
        
        secondQuestionView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(firstQuestionView.snp.bottom).offset(24)
            make.height.equalTo(260)
        }
        
        thirdQuestionView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(secondQuestionView.snp.bottom).offset(24)
            make.height.equalTo(260)
        }
        
        fourthQuestionView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(thirdQuestionView.snp.bottom).offset(24)
            make.height.equalTo(260)
        }
        
        fillLabel.snp.makeConstraints { make in
            make.top.equalTo(fourthQuestionView.snp.bottom).offset(24)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
        
        fillInformationLabel.snp.makeConstraints { make in
            make.top.equalTo(fillLabel.snp.bottom).offset(4)
            make.leading.equalTo(fillLabel.snp.leading)
        }
        
        fillPointStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.top.equalTo(fillInformationLabel.snp.bottom).offset(24)
            make.height.equalTo(72)
        }
        
        registerButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.top.equalTo(fillPointStackView.snp.bottom).offset(32)
            make.height.equalTo(54)
        }
        
        guard let parent = parent else { return }
        registerButton.snp.makeConstraints { make in
            make.bottom.equalTo(parent.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
    
    override func configUI() {
        setAttributedIndexLabel()
        setPointViews()
        selectPointView()
        validateInput()
    }
    
    func setAttributedIndexLabel() {
        setAttributedText(originString: .first, targetView: firstQuestionView, "좋았던 점")
        setAttributedText(originString: .second, targetView: secondQuestionView, "아쉬웠던 점", "부족했던 점")
        setAttributedText(originString: .third, targetView: thirdQuestionView, "배운 점")
        setAttributedText(originString: .fourth, targetView: fourthQuestionView, "얻고자")
    }
    
    func setAttributedText(originString: IndexTextStyle, targetView: IndexView, _ targetText: String...) {
        let attributedText = NSMutableAttributedString(string: originString.rawValue)
        
        for target in targetText {
            attributedText.setColorForText(textForAttribute: target, withColor: .pointPurple)
        }
        
        targetView.labelText
            .onNext(attributedText)
    }
    
    func setPointViews() {
        lowestPointView.image
            .onNext(ImageLiteral.imgBeforeSelected1)
        lowestPointView.pointText
            .onNext(PointTextStyle.lowest.rawValue)
        
        lowerPointView.image
            .onNext(ImageLiteral.imgBeforeSelected2)
        lowerPointView.pointText
            .onNext(PointTextStyle.lower.rawValue)
        
        middlePointView.image
            .onNext(ImageLiteral.imgBeforeSelected3)
        middlePointView.pointText
            .onNext(PointTextStyle.middle.rawValue)
        
        higherPointView.image
            .onNext(ImageLiteral.imgBeforeSelected4)
        higherPointView.pointText
            .onNext(PointTextStyle.higher.rawValue)
        
        highestPointView.image
            .onNext(ImageLiteral.imgBeforeSelected5)
        highestPointView.pointText
            .onNext(PointTextStyle.highest.rawValue)
    }
    
    /// 스택뷰에서 탭된 이미지만 after select로 변경
    func selectPointView() {
        lowestPointView.pointButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.fillSelected.onNext(true)
                
                self.lowestPointView.pointButton.setBackgroundImage(ImageLiteral.imgAfterSelected1, for: .normal)
                self.lowestPointView.pointLabel.textColor = .primary
                
                self.lowerPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected2, for: .normal)
                self.lowerPointView.pointLabel.textColor = .gray02
                
                self.middlePointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected3, for: .normal)
                self.middlePointView.pointLabel.textColor = .gray02
                
                self.higherPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected4, for: .normal)
                self.higherPointView.pointLabel.textColor = .gray02
                
                self.highestPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected5, for: .normal)
                self.highestPointView.pointLabel.textColor = .gray02
            })
            .disposed(by: disposeBag)
        
        lowerPointView.pointButton.rx.tap
            .subscribe(onNext: {
                self.fillSelected.onNext(true)
                
                self.lowestPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected1, for: .normal)
                self.lowestPointView.pointLabel.textColor = .gray02
                
                self.lowerPointView.pointButton.setBackgroundImage(ImageLiteral.imgAfterSelected2, for: .normal)
                self.lowerPointView.pointLabel.textColor = .primary
                
                self.middlePointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected3, for: .normal)
                self.middlePointView.pointLabel.textColor = .gray02
                
                self.higherPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected4, for: .normal)
                self.higherPointView.pointLabel.textColor = .gray02
                
                self.highestPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected5, for: .normal)
                self.highestPointView.pointLabel.textColor = .gray02
                
            })
            .disposed(by: disposeBag)
        
        middlePointView.pointButton.rx.tap
            .subscribe(onNext: {
                self.fillSelected.onNext(true)
                
                self.lowestPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected1, for: .normal)
                self.lowestPointView.pointLabel.textColor = .gray02
                
                self.lowerPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected2, for: .normal)
                self.lowerPointView.pointLabel.textColor = .gray02
                
                self.middlePointView.pointButton.setBackgroundImage(ImageLiteral.imgAfterSelected3, for: .normal)
                self.middlePointView.pointLabel.textColor = .primary
                
                self.higherPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected4, for: .normal)
                self.higherPointView.pointLabel.textColor = .gray02
                
                self.highestPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected5, for: .normal)
                self.highestPointView.pointLabel.textColor = .gray02
                
            })
            .disposed(by: disposeBag)
        
        higherPointView.pointButton.rx.tap
            .subscribe(onNext: {
                self.fillSelected.onNext(true)
                
                self.lowestPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected1, for: .normal)
                self.lowestPointView.pointLabel.textColor = .gray02
                
                self.lowerPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected2, for: .normal)
                self.lowerPointView.pointLabel.textColor = .gray02
                
                self.middlePointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected3, for: .normal)
                self.middlePointView.pointLabel.textColor = .gray02
                
                self.higherPointView.pointButton.setBackgroundImage(ImageLiteral.imgAfterSelected4, for: .normal)
                self.higherPointView.pointLabel.textColor = .primary
                
                self.highestPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected5, for: .normal)
                self.highestPointView.pointLabel.textColor = .gray02
                
            })
            .disposed(by: disposeBag)
        
        highestPointView.pointButton.rx.tap
            .subscribe(onNext: {
                self.fillSelected.onNext(true)
                
                self.lowestPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected1, for: .normal)
                self.lowestPointView.pointLabel.textColor = .gray02
                
                self.lowerPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected2, for: .normal)
                self.lowerPointView.pointLabel.textColor = .gray02
                
                self.middlePointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected3, for: .normal)
                self.middlePointView.pointLabel.textColor = .gray02
                
                self.higherPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected4, for: .normal)
                self.higherPointView.pointLabel.textColor = .gray02
                
                self.highestPointView.pointButton.setBackgroundImage(ImageLiteral.imgAfterSelected5, for: .normal)
                self.highestPointView.pointLabel.textColor = .primary
            })
            .disposed(by: disposeBag)
    }
    
    /// 입력 유효성 검사
    func validateInput() {
        let firstObservable = firstQuestionView.textView.rx.text
            .compactMap { $0 }
            .map { $0 != "내용을 입력해주세요!" ? $0.count : 0}
        
        let secondObservable = secondQuestionView.textView.rx.text
            .compactMap { $0 }
            .map { $0 != "내용을 입력해주세요!" ? $0.count : 0}
        
        let thirdObservable = thirdQuestionView.textView.rx.text
            .compactMap { $0 }
            .map { $0 != "내용을 입력해주세요!" ? $0.count : 0}
        
        let fourthObservable = fourthQuestionView.textView.rx.text
            .compactMap { $0 }
            .map { $0 != "내용을 입력해주세요!" ? $0.count : 0}
        
        Observable.combineLatest(firstObservable, secondObservable, thirdObservable, fourthObservable, fillSelected) { first, second, third, fourth, fill -> Bool in
            if first > 0 && second > 0 && third > 0 && fourth > 0 && fill {
                return true
            } else {
                return false
            }
        }
        .subscribe(onNext: { [unowned self] in
            if $0 {
                self.registerButton.backgroundColor = .primary
                self.registerButton.isEnabled = true
            } else {
                self.registerButton.backgroundColor = .init(hex: "#ADBED6")
                self.registerButton.isEnabled = false
            }
        })
        .disposed(by: disposeBag)
            
    }
}
