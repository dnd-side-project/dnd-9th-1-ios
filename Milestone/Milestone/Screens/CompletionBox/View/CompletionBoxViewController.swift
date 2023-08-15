//
//  CompletionBoxViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/11.
//

import UIKit

import SnapKit
import Then

class CompletionBoxViewController: BaseViewController, ViewModelBindableType {
    
    // MARK: subviews
    private let emptyImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgcompletionEmpty
            $0.contentMode = .scaleAspectFit
        }
    
    private let label = UILabel()
        .then {
            $0.text = "완료한 목표들이 채워질 예정이예요!\n완료함을 차곡차곡 쌓아볼까요?"
            $0.numberOfLines = 0
            $0.textColor = .gray02
            $0.font = UIFont.pretendard(.semibold, ofSize: 18)
            $0.setLineSpacing(lineHeightMultiple: 1.3)
            $0.textAlignment = .center
        }
    
    private let alertBox = UIView()
        .then {
            $0.isHidden = true
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .white
        }
    
    // MARK: Properties
//    var coordinator: CompletionViewFlow? 파일이 없다고 에러나길래 일단 주석처리 해뒀습니다!
    
    var viewModel: CompletionViewModel!
    
    // MARK: functions
    
    override func render() {
        view.addSubViews([emptyImageView, label, alertBox])
        
        emptyImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(24)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        alertBox.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(60)
        }
    }
    
    override func configUI() {
        view.backgroundColor = .gray01
        
        bindViewModel()
    }
    
    func bindViewModel() {
        
        viewModel.goalList
            .subscribe(onNext: { [weak self] elem in
                if(elem.isEmpty) {
                    self?.alertBox.isHidden = true
                    self?.emptyImageView.isHidden = false
                    self?.label.isHidden = false
                } else {
                    self?.alertBox.isHidden = false
                    self?.emptyImageView.isHidden = true
                    self?.label.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
}
