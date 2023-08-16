//
//  PointView.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/16.
//

import UIKit
import RxCocoa
import RxSwift

class PointView: UIView {
    
    // MARK: Subviews
    let pointButton = UIButton(type: .system)
        .then {
            $0.backgroundColor = .clear
        }
    
    let pointLabel = UILabel()
        .then {
            $0.font = .pretendard(.semibold, ofSize: 12)
            $0.textColor = .gray02
        }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        render()
        configUI()
    }
    
    // MARK: Properties
    var image = PublishSubject<UIImage>()
    var pointText = PublishSubject<String>()
    var disposeBag = DisposeBag()
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        self.addSubViews([pointButton, pointLabel])
        
        pointButton.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading).offset(4)
            make.trailing.equalTo(self.snp.trailing).offset(-4)
            make.height.equalTo(pointButton.snp.width)
        }
        
        pointLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    func configUI() {
        image
            .bind(to: pointButton.rx.backgroundImage(for: .normal))
            .disposed(by: disposeBag)
        
        pointText
            .bind(to: pointLabel.rx.text)
            .disposed(by: disposeBag)
    }

}
