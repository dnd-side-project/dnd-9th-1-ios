//
//  AppCoordinator.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/12.
//

import UIKit
import RxSwift

class AppCoordinator: Coordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let startCoordinator = LoginCoordinator(navigationController: navigationController)
        coordinate(to: startCoordinator)
    }
}
