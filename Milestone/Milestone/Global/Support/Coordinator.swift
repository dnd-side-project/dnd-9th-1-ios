//
//  Coordinator.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/13.
//

import Foundation

protocol Coordinator {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}
