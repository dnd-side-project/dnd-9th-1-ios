//
//  OnboardingViewControllerLast.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/13.
//

import UIKit

class OnboardingViewControllerLast: BaseViewController {
    
    var coordinator: OnboardingFlow?
    
    let onboardingImageView = UIImageView()
        .then {
            $0.image = #imageLiteral(resourceName: "onboarding2")
            $0.contentMode = .scaleAspectFit
        }
    
    let label = UILabel()
        .then {
            $0.font = UIFont.pretendard(.semibold, ofSize: 24)
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.setLineSpacing(lineSpacing: 32)
            let stringValue = "목표를 이룰 준비가 됐어요!\n보석을 찾으러 가볼까요?"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
            attributedString.setColorForText(textForAttribute: "목표를 이룰 준비가 됐어요!", withColor: .primary)
            attributedString.setColorForText(textForAttribute: "보석을 찾으러 가볼까요?", withColor: .black)
            
            $0.attributedText = attributedString
        }
    
    let completeButton = UIButton(type: .system)
        .then {
            $0.backgroundColor = .gray06
            $0.setTitle("시작하기", for: .normal)
            $0.setTitleColor(UIColor.white, for: .normal)
            $0.backgroundColor = .gray06
            $0.layer.cornerRadius = 20
            $0.titleLabel?.font = UIFont.pretendard(.semibold, ofSize: 16)
            $0.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        }
    
    @objc func completeButtonTapped(_ sender: UIButton) {
        coordinator?.coordinateToMain()
    }
    
    override func render() {
        view.addSubViews([onboardingImageView, label, completeButton])
        
        onboardingImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(120)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(onboardingImageView.snp.bottom).offset(32)
        }
        
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(54)
        }
    }
    
    override func configUI() {
        self.view.backgroundColor = .systemBackground
    }
}
