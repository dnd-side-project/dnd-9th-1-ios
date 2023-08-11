//
//  Scene.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/11.
//

import UIKit

/// 연관된 뷰모델을 열거형 내에 추가
enum Scene{
    case onboarding(OnboardingViewModel)
}

extension Scene{
    func instantiate() -> UIViewController{
        switch self {
        case .onboarding(let onboardingViewModel):
            let nav = UINavigationController()
            
            guard var onboardingVC = nav.viewControllers.first as? OnboardingViewController else {
                fatalError("Cannot Get Onboarding ViewController")
            }
            
            // MARK: 비동기적으로 바인딩 해야 바인딩 시점에 네비게이션 컨트롤러 large title과 같은 내부 속성들이 잘 적용됨
            DispatchQueue.main.async {
                onboardingVC.bind(viewModel: onboardingViewModel)
            }
            
            return nav
        }
    }
}
