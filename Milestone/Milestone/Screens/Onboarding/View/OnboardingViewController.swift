//
//  OnboardingViewController.swift
//  Milestone
//
//  Created by 박경준 on 2023/09/26.
//

import UIKit

import RxSwift

class OnboardingViewController: BaseViewController {
    
    // MARK: - Subviews
    
    let pageControl = UIPageControl()
        .then {
            $0.pageIndicatorTintColor = .gray02
            $0.currentPageIndicatorTintColor = .primary
            $0.numberOfPages = 4
        }
    
    lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        .then {
            $0.dataSource = self
            $0.delegate = self
            $0.setViewControllers([self.coordinator!.viewControllers[0]], direction: .forward, animated: true)
        }
    
    // MARK: - Properties
    
    var currentPage: Int = 0 {
        didSet {
            // from segmentedControl -> pageViewController 업데이트
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [self.coordinator!.viewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
    var coordinator: OnboardingFlow?
    
    // MARK: - Functions
    
    override func configUI() {
        view.backgroundColor = .init(hex: "#F7F7F9")
        pageControl.layer.zPosition = 999
        
        coordinator?.pageIndex.subscribe(onNext: { [unowned self] in
            self.currentPage = $0
            self.pageControl.currentPage = $0
        })
        .disposed(by: disposeBag)
    }
    
    override func render() {
        [pageControl, pageViewController.view].forEach { view.addSubview($0) }
        
        pageViewController.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-118)
        }
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllers = self.coordinator?.viewControllers,
            let index = viewControllers.firstIndex(of: viewController),
              index - 1 >= 0 else { return nil }
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllers = self.coordinator?.viewControllers,
            let index = viewControllers.firstIndex(of: viewController),
              index + 1 < viewControllers.count else { return nil }
        return viewControllers[index + 1]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[0],
              let viewControllers = self.coordinator?.viewControllers,
              let index = viewControllers.firstIndex(of: viewController) else { return }
        self.pageControl.currentPage = index
        self.coordinator?.pageIndex.accept(index)
    }
}
