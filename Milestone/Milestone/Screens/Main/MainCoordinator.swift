//
//  MainCoordinator.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/14.
//

import UIKit

enum CoordinateDirection {
    case previous
    case after
}

protocol MainFlow {
    func coordinateToCompletionBox(direction: UIPageViewController.NavigationDirection)
    func coordinateToStorageBox(direction: UIPageViewController.NavigationDirection)
    func coordinateToFillBox(direction: UIPageViewController.NavigationDirection)
    func coordinate(to index: Int, direction: UIPageViewController.NavigationDirection)
    func coordinate(to direction: CoordinateDirection)
    var pageViewController: UIPageViewController? { get set }
}

class MainCoordinator: Coordinator, MainFlow {
    
    let navigationController: UINavigationController
    var pageViewController: UIPageViewController?
    
    private let storageBoxVC = StorageBoxViewController()
    private let fillBoxVC = FillBoxViewController()
    private let completionVC = CompletionBoxViewController()
    var viewControllers: [UIViewController] { [self.storageBoxVC, self.fillBoxVC, self.completionVC] }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainVC = MainViewController()
//        mainVC.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(mainVC, animated: true)
    }
    
    func coordinate(to index: Int, direction: UIPageViewController.NavigationDirection) {
        switch index {
        case 0:
            coordinateToStorageBox(direction: direction)
        case 1:
            coordinateToFillBox(direction: direction)
        case 2:
            coordinateToCompletionBox(direction: direction)
        default:
            break
        }
    }
    
    func coordinate(to direction: CoordinateDirection) {
        switch direction {
        case .after:
            
            print("after")
        case .previous:
            print("previ")
        }
    }
    
    func coordinateToFillBox(direction: UIPageViewController.NavigationDirection) {
        pageViewController?.setViewControllers([fillBoxVC], direction: direction, animated: true)
        print("FILL")
    }
    
    func coordinateToStorageBox(direction: UIPageViewController.NavigationDirection) {
        pageViewController?.setViewControllers([storageBoxVC], direction: direction, animated: true)
        print("STORAGE")
    }
    
    func coordinateToCompletionBox(direction: UIPageViewController.NavigationDirection) {
        pageViewController?.setViewControllers([completionVC], direction: direction, animated: true)
        print("COMPLETION")
    }
}
