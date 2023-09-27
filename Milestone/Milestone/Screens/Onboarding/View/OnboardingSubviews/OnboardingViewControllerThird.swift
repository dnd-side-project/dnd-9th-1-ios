//
//  OnboardingViewControllerThird.swift
//  Milestone
//
//  Created by 박경준 on 2023/09/26.
//

import UIKit

class OnboardingViewControllerThird: BaseViewController {
    
    // MARK: - Subviews
    
    let backgroundImageViewFirst = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFit
            $0.image = ImageLiteral.imgOnboarding4_1
        }
    
    let backgroundImageViewSecond = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFill
            $0.image = ImageLiteral.imgOnboarding4_2
        }
    
    lazy var nextButton = RoundedButton(type: .system)
        .then {
            $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
            $0.titleLabel?.font = UIFont.pretendard(.semibold, ofSize: 16)
            $0.setTitleColor(.white, for: .normal)
            $0.setTitle("다음으로", for: .normal)
            $0.buttonState = .original
            $0.buttonComponentStyle = .primary_l
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
            $0.numberOfLines = 0
            $0.text = "큰 목표를 작게 쪼개어\n작은 목표를 설정해보세요!"
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = 1.2
            style.alignment = .center
            let attributes = [NSMutableAttributedString.Key.paragraphStyle: style, NSMutableAttributedString.Key.font: UIFont.pretendard(.semibold, ofSize: 22)]
            $0.attributedText = NSAttributedString(string: $0.text ?? "", attributes: attributes)
        }
    
    let subLabel = UILabel()
        .then {
            $0.textAlignment = .center
            $0.textColor = .gray03
            $0.font = .pretendard(.semibold, ofSize: 14)
            $0.text = "작은 목표는 목표에 대한 부담을 줄일 수 있어요"
        }
    
    // MARK: - Properties

    var coordinator: OnboardingCoordinator?
    
    // MARK: - Functions
    override func configUI() {
        backgroundImageViewFirst.layer.zPosition = 999
    }
    
    override func render() {
        [skipButton, backgroundImageViewFirst, backgroundImageViewSecond, nextButton, diamondImage, mainLabel, subLabel].forEach { view.addSubview($0) }
        
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
        
        backgroundImageViewFirst.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-60)
            make.top.equalTo(subLabel.snp.bottom).offset(48)
        }
        
        backgroundImageViewSecond.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(backgroundImageViewFirst.snp.bottom).offset(-32)
        }
    }
    
    // MARK: - Objc functions
    @objc func nextButtonTapped() {
        guard let pageVC = self.parent as? UIPageViewController else { return }
        coordinator?.coordinateToFourth(pageVC)
    }
    
    @objc func skipButtonTapped() {
        coordinator?.coordinateToTutorialFirst()
    }
}
