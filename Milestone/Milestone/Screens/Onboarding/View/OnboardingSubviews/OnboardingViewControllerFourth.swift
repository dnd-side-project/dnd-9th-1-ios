//
//  OnboardingViewControllerFourth.swift
//  Milestone
//
//  Created by 박경준 on 2023/09/26.
//

import UIKit

class OnboardingViewControllerFourth: BaseViewController {
    
    // MARK: - Subviews
    
    let backgroundImageView = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFill
            $0.image = ImageLiteral.imgOnboarding5
        }
    
    lazy var nextButton = RoundedButton(type: .system)
        .then {
            $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
            $0.titleLabel?.font = UIFont.pretendard(.semibold, ofSize: 16)
            $0.setTitleColor(.white, for: .normal)
            $0.setTitle("목표 만들러 가기", for: .normal)
            $0.buttonState = .original
            $0.buttonComponentStyle = .secondary_l
        }
    
    lazy var skipButton = UIButton(type: .system)
        .then {
            $0.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
            $0.setTitleColor(.gray02, for: .normal)
            $0.titleLabel?.font = UIFont.pretendard(.semibold, ofSize: 16)
            $0.backgroundColor = .clear
            $0.setTitle("건너뛰기", for: .normal)
        }
    
    let diamondImage = UIImageView()
        .then {
            $0.image = ImageLiteral.imgCompletedGoal
        }
    
    let mainLabel = UILabel()
        .then {
            $0.text = "목표를 모두 완료하고\n돌 안에 숨겨진 보석을 찾아보세요!"
            $0.numberOfLines = 0
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = 1.2
            style.alignment = .center
            let attributes = [NSMutableAttributedString.Key.paragraphStyle: style, NSMutableAttributedString.Key.font: UIFont.pretendard(.semibold, ofSize: 22)]
            $0.attributedText = NSAttributedString(string: $0.text ?? "", attributes: attributes)
        }
    
    let subLabel = UILabel()
        .then {
            $0.font = .pretendard(.semibold, ofSize: 14)
            $0.textColor = .gray03
            $0.text = "다양한 종류의 보석을 함께 모아봐요"
        }
    
    // MARK: - Properties
    
    var coordinator: OnboardingCoordinator?
    
    // MARK: - Functions
    
    override func configUI() {
        
    }
    
    override func render() {
        [skipButton, backgroundImageView, nextButton, diamondImage, mainLabel, subLabel].forEach { view.addSubview($0) }
        
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(36)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(54)
        }
        
        diamondImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(24)
            make.top.equalTo(skipButton.snp.bottom).offset(42)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(diamondImage.snp.bottom).offset(16)
        }
        
        subLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainLabel.snp.bottom).offset(7)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(subLabel.snp.bottom).offset(48)
        }
    }
    
    // MARK: - Objc functions
    
    @objc func nextButtonTapped() {
        guard let pageVC = self.parent as? UIPageViewController else { return }
        coordinator?.coordinateToTutorialFirst()
    }
    
    @objc func skipButtonTapped() {
        coordinator?.coordinateToTutorialFirst()
    }
}
