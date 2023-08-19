//
//  UpdateButtonStateDelegate.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/20.
//

import UIKit

/// 버튼의 상태를 업데이트 해주는 델리게이트 패턴
/// 서브뷰에서 버튼의 상태를 업데이트 할 때 사용함
protocol UpdateButtonStateDelegate: AnyObject {
    func updateButtonState(_ state: ButtonState)
}
