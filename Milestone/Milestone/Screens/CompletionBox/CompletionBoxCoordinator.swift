//
//  CompletionBoxCoordinator.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/16.
//

import UIKit

protocol CompletionBoxFlow {
    func coordinateToNext()
    func coordinateToMain()
}

class CompletionBoxCoordinator: Coordinator, CompletionBoxFlow {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func coordinateToNext() {
        
    }
    
    func coordinateToMain() {
        
    }
}
