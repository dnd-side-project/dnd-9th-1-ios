//
//  IndexViewAfterSaved.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/17.
//

import UIKit

import RxCocoa
import RxSwift

class IndexViewAfterSaved: UIView {
    
    // MARK: Subviews
    
    let indexView = UIImageView()
    
    let indexLabel = UILabel()
        .then {
            $0.font = UIFont.pretendard(.semibold, ofSize: 16)
        }
    
    let textView = UITextView()
        .then {
            $0.isScrollEnabled = false
            $0.textContainerInset = UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 24)
            $0.layer.cornerRadius = 20
            $0.font = .pretendard(.regular, ofSize: 14)
            $0.backgroundColor = .clear
            $0.isEditable = false
        }
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    
    // MARK: Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        render()
        configUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    func render() {
        self.addSubViews([indexView, indexLabel, textView])
        
        indexView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.leading.equalTo(self.snp.leading).offset(24)
            make.top.equalTo(self.snp.top)
        }
        
        indexLabel.snp.makeConstraints { make in
            make.leading.equalTo(indexView.snp.trailing).offset(8)
            make.centerY.equalTo(indexView.snp.centerY)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(24)
            make.trailing.equalTo(self.snp.trailing).offset(-24)
            make.top.equalTo(indexView.snp.bottom).offset(16)
        }
    }
    
    func configUI() {
        
        textView.rx.text
            .compactMap { $0 }
            .map { str -> NSAttributedString in
                let style = NSMutableParagraphStyle()
                style.lineHeightMultiple = 1.4
                let attributes = [NSMutableAttributedString.Key.paragraphStyle: style, NSMutableAttributedString.Key.font: UIFont.pretendard(.regular, ofSize: 14), NSMutableAttributedString.Key.foregroundColor: UIColor.black]
                return NSAttributedString(string: str, attributes: attributes)
            }
            .bind(to: textView.rx.attributedText)
            .disposed(by: disposeBag)
    }
}
