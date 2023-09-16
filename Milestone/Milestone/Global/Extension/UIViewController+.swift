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
    
    /// sheetPresentationController를 사용한 커스텀 모달을 띄우고 싶을 때 사용
    func presentCustomModal(_ viewController: UIViewController, height: CGFloat) {
        viewController.modalPresentationStyle = .pageSheet
        
        guard let sheet = viewController.sheetPresentationController else { return }
        let fraction = UISheetPresentationController.Detent.custom { _ in height }
        sheet.detents = [fraction]
        present(viewController, animated: true)
    }
    
    /// 로딩뷰 띄울때 사용
    func loading(loading: Bool) {
        if loading {
            let loadingView = LoadingView(frame: view.frame)
            view.addSubview(loadingView)
            return
        }
        
        guard let loadingView = view.subviews.compactMap({ $0 as? LoadingView }).first else { return }
        loadingView.removeFromSuperview()
    }
    
    /// "yyyy.MM.dd" 형식을 "yyyy / MM / dd" 형식으로 바꿔준다
    func changeDateFormat(_ inputDate: String) -> String? {
        let inputFormat = "yyyy.MM.dd"
        let outputFormat = "yyyy / MM / dd"
        
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = inputFormat
        
        if let date = dateFormatterInput.date(from: inputDate) {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.dateFormat = outputFormat
            return dateFormatterOutput.string(from: date)
        } else {
            return nil
        }
    }
}
