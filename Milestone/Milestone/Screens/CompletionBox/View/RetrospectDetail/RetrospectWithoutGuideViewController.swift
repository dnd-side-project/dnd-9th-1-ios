//
//  CompletionReviewWithoutGuideViewController.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/16.
//

import UIKit

import RxCocoa
import RxSwift

class RetrospectWithoutGuideViewController: BaseViewController {
    
    // MARK: Subviews
    let textViewWrapper = UIView()
        .then {
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .gray01
        }
    
    let textView = UITextView()
        .then {
            $0.textContainerInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
            $0.text = "자유롭게 회고를 작성해보세요!"
            $0.backgroundColor = .gray01
            
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = 1.2
            let attributes = [NSMutableAttributedString.Key.paragraphStyle: style, NSMutableAttributedString.Key.font: UIFont.pretendard(.regular, ofSize: 14), NSMutableAttributedString.Key.foregroundColor: UIColor.gray02]
            $0.attributedText = NSAttributedString(string: $0.text, attributes: attributes)
        }
    
    let textCountLabel = UILabel()
        .then {
            $0.textAlignment = .right
            $0.backgroundColor = .gray01
            $0.font = .pretendard(.regular, ofSize: 10)
        }
    
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
    let heightSubject = PublishSubject<Int>()
    var fillSelected = PublishSubject<Bool>()
    let selectedPoint = BehaviorRelay<String>(value: "")
    let pointSelectTrigger = PublishSubject<FillPoint>()
    
    var saveButtonTapDisposable: Disposable!
    
    // MARK: Life Cycles
    
    // MARK: Functions
    override func render() {
        view.addSubView(scrollView)
        scrollView.subviews.first!.addSubViews([textViewWrapper, textView, textCountLabel, fillLabel, fillInformationLabel, fillPointStackView, registerButton])
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        textViewWrapper.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
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
        
        textCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(textViewWrapper.snp.trailing).offset(-24)
            make.bottom.equalTo(textViewWrapper.snp.bottom).offset(-24)
        }
        
        fillLabel.snp.makeConstraints { make in
            make.top.equalTo(textViewWrapper.snp.bottom).offset(24)
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
            make.top.equalTo(fillPointStackView.snp.bottom).offset(32)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(54)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-16)
        }
    }
    
    override func configUI() {
        selectPointView()
        setPointViews()
        
        textView.rx.didBeginEditing
            .subscribe(onNext: { [unowned self] in
                if self.textView.text == "자유롭게 회고를 작성해보세요!" {
                    self.textView.text = ""
                }
                self.textView.textColor = .black
            })
            .disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .subscribe(onNext: { [unowned self] in
                if self.textView.text.isEmpty {
                    self.textView.text = "자유롭게 회고를 작성해보세요!"
                    self.textView.textColor = .gray02
                }
            })
            .disposed(by: disposeBag)
        
        textView.rx.text
            .compactMap { $0 }
            .map { "\($0 == "자유롭게 회고를 작성해보세요!" ? 0 : $0.count)/1000" }
            .bind(to: textCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        textView.rx.text
            .compactMap { $0 }
            .scan("") { previous, new in
                return new.count <= 1000 ? new : previous
            }
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
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
                self.selectedPoint.accept("LEVEL1")
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
                
                pointSelectTrigger.onNext(.level1)
            })
            .disposed(by: disposeBag)
        
        lowerPointView.pointButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.selectedPoint.accept("LEVEL2")
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
              
                pointSelectTrigger.onNext(.level2)
            })
            .disposed(by: disposeBag)
        
        middlePointView.pointButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.selectedPoint.accept("LEVEL3")
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
                
                pointSelectTrigger.onNext(.level3)
            })
            .disposed(by: disposeBag)
        
        higherPointView.pointButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.selectedPoint.accept("LEVEL4")
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
                
                pointSelectTrigger.onNext(.level4)
            })
            .disposed(by: disposeBag)
        
        highestPointView.pointButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.selectedPoint.accept("LEVEL5")
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
                
                pointSelectTrigger.onNext(.level5)
            })
            .disposed(by: disposeBag)
    }
}
