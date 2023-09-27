//
//  OnboardingViewControllerSecond.swift
//  Milestone
//
//  Created by 박경준 on 2023/09/26.
//

import UIKit

class OnboardingViewControllerSecond: BaseViewController {
    // MARK: Subviews
    let backgroundImageView = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFill
            $0.image = ImageLiteral.imgOnboarding3
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
    
    let firstLabel = UILabel()
        .then {
            $0.numberOfLines = 0
            $0.text = "목표는 세웠지만 멀게만\n느껴져 포기하신적 없으신가요?"
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = 1.2
            style.alignment = .center
            let attributes = [NSMutableAttributedString.Key.paragraphStyle: style, NSMutableAttributedString.Key.font: UIFont.pretendard(.semibold, ofSize: 22)]
            $0.attributedText = NSAttributedString(string: $0.text ?? "", attributes: attributes)
        }
    
    let lastLabel = UILabel()
        .then {
            $0.numberOfLines = 0
            $0.text = "차근차근 목표에 다가갈 수 있도록\nMileStone이 도와드릴게요!"
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = 1.2
            style.alignment = .center
            let attributes = [NSMutableAttributedString.Key.paragraphStyle: style, NSMutableAttributedString.Key.font: UIFont.pretendard(.semibold, ofSize: 22)]
            $0.attributedText = NSAttributedString(string: $0.text ?? "", attributes: attributes)
        }
    
    // MARK: - Properties
    
    var coordinator: OnboardingCoordinator?
    
    // MARK: - Functions
    override func configUI() {
        
    }
    
    override func render() {
        [skipButton, backgroundImageView, nextButton, diamondImage, firstLabel, lastLabel].forEach { view.addSubview($0) }
        
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
        
        firstLabel.snp.makeConstraints { make in
            make.top.equalTo(diamondImage.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        lastLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(lastLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(330)
        }
    }
    
    @objc func nextButtonTapped() {
        guard let pageVC = self.parent as? UIPageViewController else { return }
        coordinator?.coordinateToThird(pageVC)
    }
    
    @objc func skipButtonTapped() {
        coordinator?.coordinateToTutorialFirst()
    }
}
