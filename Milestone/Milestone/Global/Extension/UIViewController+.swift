//
//  UIViewController+.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/12.
//

import UIKit

extension UIViewController {
    /// UINavigationController가 없는 VC에서 push 하고 싶을 때 사용
    func push(viewController: UIViewController) {
        if let keyWindow = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow }).last,
           let navigationController = keyWindow.rootViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    /// 현재 VC를 pop하여 이전 화면으로 전환하고 싶을 때 사용
    @objc
    func pop() {
        navigationController?.popViewController(animated: true)
    }
}
