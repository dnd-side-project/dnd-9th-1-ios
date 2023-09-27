//
//  OnboardingCoordinator.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/13.
//

import UIKit

import RxSwift
import RxCocoa

protocol OnboardingFlow {
    var viewControllers: [UIViewController] { get }
    var pageIndex: BehaviorRelay<Int> { get }
    
    func coordinateToSecond(_ pageViewController: UIPageViewController)
    func coordinateToThird(_ pageViewController: UIPageViewController)
    func coordinateToFourth(_ pageViewController: UIPageViewController)
    func coordinateToTutorialFirst()
    func coordinateToTutorialLast()
    func coordinateToMain()
}

class OnboardingCoordinator: Coordinator, OnboardingFlow {
    let navigationController: UINavigationController
    
    private let firstVC = OnboardingViewControllerFirst()
    private let secondVC = OnboardingViewControllerSecond()
    private let thirdVC = OnboardingViewControllerThird()
    private let fourthVC = OnboardingViewControllerFourth()
    
    lazy var viewControllers: [UIViewController] = [firstVC, secondVC, thirdVC, fourthVC]
    var pageIndex = BehaviorRelay<Int>(value: 0)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        firstVC.coordinator = self
        secondVC.coordinator = self
        thirdVC.coordinator = self
        fourthVC.coordinator = self
    }
    
    func start() {
        let onboardingVC = OnboardingViewController()
//        onboardingVC.viewModel = OnboardingViewModel()
        onboardingVC.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(onboardingVC, animated: true)
    }
    
    func coordinateToSecond(_ pageViewController: UIPageViewController) {
        pageViewController.setViewControllers([viewControllers[1]], direction: .forward, animated: true)
        pageIndex.accept(1)
    }
    
    func coordinateToThird(_ pageViewController: UIPageViewController) {
        pageViewController.setViewControllers([viewControllers[2]], direction: .forward, animated: true)
        pageIndex.accept(2)
    }
    
    func coordinateToFourth(_ pageViewController: UIPageViewController) {
        pageViewController.setViewControllers([viewControllers[3]], direction: .forward, animated: true)
        pageIndex.accept(3)
    }
    
    func coordinateToTutorialFirst() {
        let tutorialVC = OnboardingViewControllerTutorialFirst()
        tutorialVC.viewModel = OnboardingViewModel()
        tutorialVC.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(tutorialVC, animated: true)
    }
    
    func coordinateToTutorialLast() {
        let tutorialVC = OnboardingViewControllerTutorialLast()
        tutorialVC.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(tutorialVC, animated: true)
    }
    
    func coordinateToMain() {
        navigationController.pushViewController(MainViewController(), animated: true)
    }
}
