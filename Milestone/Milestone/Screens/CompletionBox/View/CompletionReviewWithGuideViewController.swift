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
    
    enum IndexText: String {
        case first = "좋았던 점은 무엇인가요?"
        case second = "아쉬웠던 점이나, 부족했던 점은 무엇인가요?"
        case third = "배운 점은 무엇인가요?"
        case fourth = "목표를 통해 뭘 얻고자 하셨나요?"
    }
    
    enum PointText: String {
        case lowest = "별로예요"
        case lower = "아쉬워요"
        case middle = "그저 그랬어요"
        case higher = "만족해요"
        case highest = "완전 만족해요"
    }
    
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
            make.height.equalTo(244)
        }
        
        secondQuestionView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(firstQuestionView.snp.bottom).offset(24)
            make.height.equalTo(244)
        }
        
        thirdQuestionView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(secondQuestionView.snp.bottom).offset(24)
            make.height.equalTo(244)
        }
        
        fourthQuestionView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(thirdQuestionView.snp.bottom).offset(24)
            make.height.equalTo(244)
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
    }
    
    func setAttributedIndexLabel() {
        setAttributedText(originString: .first, targetView: firstQuestionView, "좋았던 점")
        setAttributedText(originString: .second, targetView: secondQuestionView, "아쉬웠던 점", "부족했던 점")
        setAttributedText(originString: .third, targetView: thirdQuestionView, "배운 점")
        setAttributedText(originString: .fourth, targetView: fourthQuestionView, "얻고자")
    }
    
    func setAttributedText(originString: IndexText, targetView: IndexView, _ targetText: String...) {
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
            .onNext(PointText.lowest.rawValue)
        
        lowerPointView.image
            .onNext(ImageLiteral.imgBeforeSelected2)
        lowerPointView.pointText
            .onNext(PointText.lower.rawValue)
        
        middlePointView.image
            .onNext(ImageLiteral.imgBeforeSelected3)
        middlePointView.pointText
            .onNext(PointText.middle.rawValue)
        
        higherPointView.image
            .onNext(ImageLiteral.imgBeforeSelected4)
        higherPointView.pointText
            .onNext(PointText.higher.rawValue)
        
        highestPointView.image
            .onNext(ImageLiteral.imgBeforeSelected5)
        highestPointView.pointText
            .onNext(PointText.highest.rawValue)
    }
    
    /// 스택뷰에서 탭된 이미지만 after select로 변경
    func selectPointView() {
        lowestPointView.pointButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.lowestPointView.pointButton.setBackgroundImage(ImageLiteral.imgAfterSelected1, for: .normal)
                self.lowestPointView.pointLabel.textColor = .black
                
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
                self.lowestPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected1, for: .normal)
                self.lowestPointView.pointLabel.textColor = .gray02
                
                self.lowerPointView.pointButton.setBackgroundImage(ImageLiteral.imgAfterSelected2, for: .normal)
                self.lowerPointView.pointLabel.textColor = .black
                
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
                self.lowestPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected1, for: .normal)
                self.lowestPointView.pointLabel.textColor = .gray02
                
                self.lowerPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected2, for: .normal)
                self.lowerPointView.pointLabel.textColor = .gray02
                
                self.middlePointView.pointButton.setBackgroundImage(ImageLiteral.imgAfterSelected3, for: .normal)
                self.middlePointView.pointLabel.textColor = .black
                
                self.higherPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected4, for: .normal)
                self.higherPointView.pointLabel.textColor = .gray02
                
                self.highestPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected5, for: .normal)
                self.highestPointView.pointLabel.textColor = .gray02
                
            })
            .disposed(by: disposeBag)
        
        higherPointView.pointButton.rx.tap
            .subscribe(onNext: {
                self.lowestPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected1, for: .normal)
                self.lowestPointView.pointLabel.textColor = .gray02
                
                self.lowerPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected2, for: .normal)
                self.lowerPointView.pointLabel.textColor = .gray02
                
                self.middlePointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected3, for: .normal)
                self.middlePointView.pointLabel.textColor = .gray02
                
                self.higherPointView.pointButton.setBackgroundImage(ImageLiteral.imgAfterSelected4, for: .normal)
                self.higherPointView.pointLabel.textColor = .black
                
                self.highestPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected5, for: .normal)
                self.highestPointView.pointLabel.textColor = .gray02
                
            })
            .disposed(by: disposeBag)
        
        highestPointView.pointButton.rx.tap
            .subscribe(onNext: {
                self.lowestPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected1, for: .normal)
                self.lowestPointView.pointLabel.textColor = .gray02
                
                self.lowerPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected2, for: .normal)
                self.lowerPointView.pointLabel.textColor = .gray02
                
                self.middlePointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected3, for: .normal)
                self.middlePointView.pointLabel.textColor = .gray02
                
                self.higherPointView.pointButton.setBackgroundImage(ImageLiteral.imgBeforeSelected4, for: .normal)
                self.higherPointView.pointLabel.textColor = .gray02
                
                self.highestPointView.pointButton.setBackgroundImage(ImageLiteral.imgAfterSelected5, for: .normal)
                self.highestPointView.pointLabel.textColor = .black
            })
            .disposed(by: disposeBag)
    }
}
