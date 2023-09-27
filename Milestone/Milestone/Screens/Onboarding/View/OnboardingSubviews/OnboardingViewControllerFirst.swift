//
//  OnboardingViewControllerFirst.swift
//  Milestone
//
//  Created by 박경준 on 2023/09/26.
//

import UIKit

class OnboardingViewControllerFirst: BaseViewController {
    
    // MARK: Subviews
    let backgroundImageView = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFill
            $0.image = ImageLiteral.imgOnboarding2
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
    
    let greetLabel = UILabel()
        .then {
            $0.textAlignment = .center
            $0.font = .pretendard(.semibold, ofSize: 22)
            $0.text = "반가워요!"
        }
    
    let label = UILabel()
        .then {
            $0.numberOfLines = 0
            $0.font = .pretendard(.semibold, ofSize: 22)
            $0.text = "저는 여러분과 함께\n목표 달성을 함께 할 마일이에요"
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
            $0.text = "마일이와 함께 보석을 찾는 여정을 떠나볼까요?"
        }
    
    // MARK: - Properties
    
    var coordinator: OnboardingCoordinator?
    
    // MARK: - Functions
    override func configUI() {
        backgroundImageView.layer.zPosition = -1
    }
    
    override func render() {
        [greetLabel, label, subLabel, skipButton, backgroundImageView, nextButton].forEach { view.addSubview($0) }
    
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(36)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
        }
        
        greetLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(skipButton.snp.bottom).offset(48)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(greetLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(54)
        }
    }
    
    // MARK: - Objc functions
    @objc func nextButtonTapped() {
        guard let pageVC = self.parent as? UIPageViewController else { return }
        coordinator?.coordinateToSecond(pageVC)
    }
    
    @objc func skipButtonTapped() {
        coordinator?.coordinateToTutorialFirst()
    }
}
