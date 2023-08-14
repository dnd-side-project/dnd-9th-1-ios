//
//  OnboardingCoordinator.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/13.
//

import UIKit

protocol OnboardingFlow {
    func coordinateToNext()
}

class OnboardingCoordinator: Coordinator, OnboardingFlow {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(onboardingVC, animated: true)
    }
    
    func coordinateToNext() {
        navigationController.pushViewController(OnboardingViewControllerLast(), animated: true)
    }
}
