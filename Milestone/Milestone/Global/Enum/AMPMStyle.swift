//
//  AMPMStyle.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/24.
//

import UIKit

/// AM PM 데이터를 나타내는 enum
/// 서버에는 AM, PM으로 보내야 하고 뷰에는 오전, 오후로 띄워야 해서 enum으로 만들었다
enum AMPMStyle: String {
    case AM = "오전"
    case PM = "오후"
    
    var caseString: String {
        String(describing: self)
    }
}
