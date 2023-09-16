//
//  IndexView.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/16.
//

import UIKit
import RxSwift
import RxCocoa

class IndexView: UIView {
    
    // MARK: Subviews
    let indexImage = UIImageView()
    
    private let indexLabel = UILabel()
        .then {
            $0.font = UIFont.pretendard(.semibold, ofSize: 16)
        }
    
    let textView = UITextView()
        .then {
            $0.textContainerInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
            $0.font = UIFont.pretendard(.regular, ofSize: 14)
            $0.text = "내용을 입력해주세요!"
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .gray01
            
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = 1.2
            let attributes = [NSMutableAttributedString.Key.paragraphStyle: style, NSMutableAttributedString.Key.font: UIFont.pretendard(.regular, ofSize: 14), NSMutableAttributedString.Key.foregroundColor: UIColor.gray02]
            $0.attributedText = NSAttributedString(string: $0.text, attributes: attributes)
        }
    
    private let textCountLabel = UILabel()
        .then {
            $0.font = UIFont.pretendard(.regular, ofSize: 10)
        }
    
    // MARK: Properties
    var labelText = PublishSubject<NSMutableAttributedString>()
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        render()
        configUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        self.addSubViews([indexImage, indexLabel, textView, textCountLabel])
        
        indexImage.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(24)
            make.top.equalTo(self.snp.top)
            make.width.height.equalTo(24)
        }
        
        indexLabel.snp.makeConstraints { make in
            make.leading.equalTo(indexImage.snp.trailing).offset(8)
            make.centerY.equalTo(indexImage.snp.centerY)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(24)
            make.trailing.equalTo(self.snp.trailing).offset(-24)
            make.top.equalTo(indexImage.snp.bottom).offset(16)
            make.height.equalTo(220)
        }
        
        textCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(textView.snp.trailing).offset(-24)
            make.bottom.equalTo(textView.snp.bottom).offset(-24)
        }
    }
    
    func configUI() {
        labelText
            .map { NSAttributedString(attributedString: $0) }
            .bind(to: indexLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        textView.rx.didBeginEditing
            .subscribe(onNext: { [unowned self] in
                if self.textView.text == "내용을 입력해주세요!" {
                    self.textView.text = ""
                }
                self.textView.textColor = .black
            })
            .disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .subscribe(onNext: { [unowned self] in
                if self.textView.text.isEmpty {
                    self.textView.text = "내용을 입력해주세요!"
                    self.textView.textColor = .gray02
                }
            })
            .disposed(by: disposeBag)
        
        textView.rx.text
            .compactMap { $0 }
            .map { "\($0 == "내용을 입력해주세요!" ? 0 : $0.count)/200" }
            .bind(to: textCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        textView.rx.text
            .compactMap { $0 }
            .scan("") { previous, new in
                return new.count <= 200 ? new : previous
            }
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)
    }
}
