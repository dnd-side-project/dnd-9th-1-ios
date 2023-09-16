//
//  OnboardingCoordinator.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/13.
//

import UIKit

protocol OnboardingFlow {
    func coordinateToNext()
    func coordinateToMain()
}

class OnboardingCoordinator: Coordinator, OnboardingFlow {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.viewModel = OnboardingViewModel()
        onboardingVC.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(onboardingVC, animated: true)
    }
    
    func coordinateToNext() {
        let onboardingLastVC = OnboardingViewControllerLast()
        onboardingLastVC.coordinator = self
        navigationController.pushViewController(onboardingLastVC, animated: true)
    }
    
    func coordinateToMain() {
        navigationController.pushViewController(MainViewController(), animated: true)
    }
}
