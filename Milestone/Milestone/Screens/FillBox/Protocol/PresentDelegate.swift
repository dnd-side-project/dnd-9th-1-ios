//
//  PresentDelegate.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/20.
//

import UIKit

/// 파라미터로 온 controller를 present 해주는 델리게이트 패턴
/// 서브뷰에서 present 시 사용함
protocol PresentDelegate: AnyObject {
    func present(alert: UIAlertController)
    func present(_ viewController: UIViewController)
}

extension PresentDelegate {
    func present(alert: UIAlertController) {
        Logger.debugDescription("Alert를 Present")
    }
    func present(_ viewController: UIViewController) {
        Logger.debugDescription("ViewController를 Present")
    }
}
